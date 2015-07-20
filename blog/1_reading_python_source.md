#准备环境
下载Python 2.7.9源码包，解压缩后，在PC目录下找到VS*目录，
里面有Visual Studio的工程文件。

#pythoncore项目
pythoncore项目是核心项目，而python只是一个包裹pythoncore的壳而已，
也就是我们经常使用的*Interactive Python*环境。

#PyObject
PyObject是python程序中最基本的对象，
我们可以在**Include/object.h**中找到这个对象的定义：

    /* Nothing is actually declared to be a PyObject, but every pointer to
     * a Python object can be cast to a PyObject*.  This is inheritance built
     * by hand.  Similarly every pointer to a variable-size Python object can,
     * in addition, be cast to PyVarObject*.
     */
    typedef struct _object {
        PyObject_HEAD
    } PyObject;

>*Python中没有什么类型是显式地定义为PyObject的，但是每一个Python中的Object都可以被转换成一个PyObject指针。*

#开始调试
以python项目作为启动项目开始调试，可以弹出Interactive Python环境。
我们想要知道输入的命令，比如：
    
    import os

是怎样被解析以及处理的，在调试过程中，我们能够看到比较惹眼的函数如：
## PyEval_EvalFrameEx 
用来解释执行python的字节码，因为Python的字节码的执行上下文是由Stack Frame来维护的

        switch (opcode) {

        /* BEWARE!
           It is essential that any operation that fails sets either
           x to NULL, err to nonzero, or why to anything but WHY_NOT,
           and that no operation that succeeds does this! */

        /* case STOP_CODE: this is an error! */

        case NOP:
            goto fast_next_opcode;

        case LOAD_FAST:
            x = GETLOCAL(oparg);
            if (x != NULL) {
                Py_INCREF(x);
                PUSH(x);
                goto fast_next_opcode;
            }
            format_exc_check_arg(PyExc_UnboundLocalError,
                UNBOUNDLOCAL_ERROR_MSG,
                PyTuple_GetItem(co->co_varnames, oparg));
            break;

## run\_pyc_file 
如果输入是一个已经编译过的文件(.pyc)，那么可以直接run\_pyc_file来处理它，这个函数将会直接调用上面的PyEval_EvalFrameEx
来处理

    if (maybe_pyc_file(fp, filename, ext, closeit)) {
        /* Try to run a pyc file. First, re-open in binary */
        if (closeit)
            fclose(fp);
        if ((fp = fopen(filename, "rb")) == NULL) {
            fprintf(stderr, "python: Can't reopen .pyc file\n");
            goto done;
        }
        /* Turn on optimization if a .pyo file is given */
        if (strcmp(ext, ".pyo") == 0)
            Py_OptimizeFlag = 1;
        v = run_pyc_file(fp, filename, d, d, flags);
    } else {
        v = PyRun_FileExFlags(fp, filename, Py_file_input, d, d,
                              closeit, flags);
    }

如果不是pyc文件，那么调用*PyRun_FileExFlags*来从头处理

## PyRun_FileExFlags
该函数首先创建arena，然后调用*PyParser_ASTFromFile*来解析源文件语法树

        PyObject *
        PyRun_FileExFlags(FILE *fp, const char *filename, int start, PyObject *globals,
                          PyObject *locals, int closeit, PyCompilerFlags *flags)
        {
            PyObject *ret;
            mod_ty mod;
            PyArena *arena = PyArena_New();
            if (arena == NULL)
                return NULL;

            mod = PyParser_ASTFromFile(fp, filename, start, 0, 0,
                                       flags, NULL, arena);
            if (closeit)
                fclose(fp);
            if (mod == NULL) {
                PyArena_Free(arena);
                return NULL;
            }
            ret = run_mod(mod, filename, globals, locals, flags, arena);
            PyArena_Free(arena);
            return ret;
        }

## PyParser_ASTFromFile
该函数首先调用*PyParser_ParseFileFlagsEx*从源文件中解析出tokens，再从节点n开始建立语法树。

        mod_ty
        PyParser_ASTFromFile(FILE *fp, const char *filename, int start, char *ps1,
                             char *ps2, PyCompilerFlags *flags, int *errcode,
                             PyArena *arena)
        {
            mod_ty mod;
            PyCompilerFlags localflags;
            perrdetail err;
            int iflags = PARSER_FLAGS(flags);

            node *n = PyParser_ParseFileFlagsEx(fp, filename, &_PyParser_Grammar,
                                    start, ps1, ps2, &err, &iflags);
            if (flags == NULL) {
                localflags.cf_flags = 0;
                flags = &localflags;
            }
            if (n) {
                flags->cf_flags |= iflags & PyCF_MASK;
                mod = PyAST_FromNode(n, flags, filename, arena);
                PyNode_Free(n);
                return mod;
            }
            else {
                err_input(&err);
                if (errcode)
                    *errcode = err.error;
                return NULL;
            }
        }

## PyParser_ParseFileFlagsEx
里面还会继续调用到parsetok函数做tokenize的工作。

        node *
        PyParser_ParseFileFlagsEx(FILE *fp, const char *filename, grammar *g, int start,
                                  char *ps1, char *ps2, perrdetail *err_ret, int *flags)
        {
            struct tok_state *tok;

            initerr(err_ret, filename);

            if ((tok = PyTokenizer_FromFile(fp, ps1, ps2)) == NULL) {
                err_ret->error = E_NOMEM;
                return NULL;
            }
            tok->filename = filename;
            if (Py_TabcheckFlag || Py_VerboseFlag) {
                tok->altwarning = (filename != NULL);
                if (Py_TabcheckFlag >= 2)
                    tok->alterror++;
            }

            return parsetok(tok, g, start, err_ret, flags);
        }
