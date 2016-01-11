Public with sharing class SOSLController{
    
    //Gegeral Lists
    Public List<contact> conList        {get;set;}
    Public List<account> accList        {get;set;}
    
    //Sort
    Public String searchStr             {get;set;}
    public String sortField             {get; set;}
    public String strField              {get; set;}
    public String previousSortField     {get; set;}
    public String imgClass              {get; set;}
    public String imgTitle              {get; set;}
    public String objectList            {get; set;}
    
    //Constructor
    Public SOSLController(){}
    
    Public void soslDemo_method(){
        conList = New List<contact>();
        accList = New List<account>();
        if(searchStr.length() > 1){
            String searchStr1 = '*'+searchStr+'*';
            String searchQuery = 'FIND \'' + searchStr1 + '\' IN ALL FIELDS RETURNING  Account (Id,Name,type),Contact(name,email, DLN__c, SSN__c)';
            List<List <sObject>> searchList = search.query(searchQuery);
            accList = (List<Account>)searchList[0];
            if(accList.size() > 0)
                DynamicSort.sortList(accList, 'name', 'asc',null);
            conList  = ((List<contact>)searchList[1]);
            if(conList.size() > 0)
                DynamicSort.sortList(conList, 'name', 'asc',null);
            if(accList.size() == 0 && conList.size() == 0){
                apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Sorry, no results returned with matching string..'));
                return;
            }
        }
        else{
            apexPages.addmessage(new apexpages.message(apexpages.severity.Error, 'Please enter at least two characters..'));
            return;
        }
    }
    public void doSort(){
        //Default value
        String order = 'asc';
        
        /*This checks to see if the same header was click two times in a row, if so
        it switches the order.*/
        if(previousSortField == sortField){
            order = 'desc';
            previousSortField = null;
            imgClass = 'sortDesc';
            imgTitle = 'Sorted Descending';
        }else{
            previousSortField = sortField;
            imgClass = 'sortAsc';
            imgTitle = 'Sorted Ascending';
        }
        //To sort the table we simply need to use this one line, nice!
        system.debug(sortField);
        if(objectList == 'accList')
            DynamicSort.sortList(accList,sortField,order,strField);
        if(objectList == 'conList')
            DynamicSort.sortList(conList,sortField,order,strField);
    }
}