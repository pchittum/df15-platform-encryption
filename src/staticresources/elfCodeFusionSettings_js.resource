elfCodeFusionSettings = { 
    snippets : {
        javascript : [ 
            {
                name: "JS sample snippet",
                tabTrigger: "jsss",
                content: ""
					+"function ${1?:function_name}(${2:argument}) {\n"
					+"	${3:// body...}\n"
					+"}\n"	
                ,
            },
            
        ],
        java : [
            {
                name: "APEX sample snippet",
                tabTrigger: "apss",
                content: ""
                    +"${1:test}.this is custom snippet text!"
                ,
            },
        ],
    }
 }
