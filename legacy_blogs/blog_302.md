$ cat prettify.sed 
    s/,/,\r\n/g
    s/\[/\r\n\[\r\n/g
    s/\]/\r\n\]\r\n/g
    s/{/\r\n{\r\n/g
    s/}/\r\n}\r\n/g
 

$ cat prettify.awk 
    BEGIN{  depth = 0;}
    /\[/ {  
            sp = 0;
            while(sp++ < depth)
                printf("    "); 
            print $0;
            
            depth += 1;
         }
    
    /{/  { 
            sp = 0;
            while(sp++ < depth)
                printf("    "); 
            print $0;
            
            depth += 1;
         }
    
    /\]/ { 
            if (depth > 1) 
                depth -= 1;
                
            sp = 0;
            while(sp++ < depth)
                printf("    "); 
            print $0;
         }
    
    /}/  { 
            if (depth > 1) 
                depth -= 1;
            
            sp = 0;
            while(sp++ < depth)
                printf("    "); 
            print $0;
         }
    
    /".*":".*"/ {sp = 0;while(sp++ < depth)printf("    "); print $0;}
 

$ cat digitalstrategy.json | sed -f prettify.sed | awk -f prettify.awk | head -50
    {
        "agency":"NSF",
        "generated":"2014-08-07 06:38:36",
        [
            {
                "id":"2.1",
                "due":"90 Days",
                "due_date":"2012\/08\/21",
                [
                    {
                        "type":"select",
                        "name":"2-1-status",
                        "label":"Overall Status",
                        [
                            {
                                "label":"Not Started",
                                "value":"not-started"
                            }
                            {
                                "label":"In Progress",
                                "value":"in-progress"
                            }
                            {
                                "label":"Completed",
                                "value":"completed"
                            }
                        ]
                        "value":"completed"
                    }
                ]
            }
            {
                "id":"2.1.1",
                "parent":"2.1",
                "text":"Paragraph on customer engagement approach",
                "due":"90 days",
                "due_date":"2012\/08\/21",
                [
                    {
                        "type":"textarea",
                        "name":"2-1-1-customer-engagement-approach",
                        "label":"Paragraph on customer engagement approach",
                        [
                        ]
                    }
                ]
            }
            {
                "id":"2.1.2",
                "parent":"2.1",
     

 

$ cat prettify.awk 
    BEGIN{  depth = 0;}
    /\[/ {  
    #        sp = 0;
    #        while(sp++ < depth)
    #            printf("    "); 
    #        print $0;
            
            depth += 1;
         }
    
    /{/  { 
    #        sp = 0;
    #        while(sp++ < depth)
    #            printf("    "); 
    #        print $0;
            
            depth += 1;
         }
    
    /\]/ { 
            if (depth > 1) 
                depth -= 1;
                
    #        sp = 0;
    #        while(sp++ < depth)
    #            printf("    "); 
    #        print $0;
         }
    
    /}/  { 
            if (depth > 1) 
                depth -= 1;
            
    #        sp = 0;
    #        while(sp++ < depth)
    #            printf("    "); 
    #        print $0;
         }
    
    {sp = 0;while(sp++ < depth)printf("    "); print $0;}
     
