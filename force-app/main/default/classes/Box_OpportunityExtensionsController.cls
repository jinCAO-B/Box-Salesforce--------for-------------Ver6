public without sharing class Box_OpportunityExtensionsController {
    private final Opportunity acct;
    
//引数に標準コントローラを指定して、メソッドを使用してレコードIDを取得します。
    public Box_OpportunityExtensionsController(ApexPages.StandardController stdController) {
        this.acct = (Opportunity)stdController.getRecord();
    }
    
   /**
     * コンストラクタ.
     * @param stdController 標準コントローラ
     */    
    
//結果表示の変数 
    public string feedback {get;set;}
    public string feedbackOk {get;set;}	 
    
//@AuraEnabled(cacheable=true) 
//@RemoteAction
    public pagereference apiCopyTemplateOpportunity(){
        String pageid = System.ApexPages.currentPage().getParameters().get('id');
        system.debug('pageid:' + pageid);
        if(pageid==null) {
            this.feedback = System.label.Box_CustomError1;
            return null;
        }
        String renameid = [SELECT Id,NegotiateID__c FROM Opportunity WHERE Id =:pageid LIMIT 1].NegotiateID__c;
        if(renameid==null){
            this.feedback = System.label.Box_CustomError1;
            return null;
        }
        String renamename = [SELECT Name,NegotiateID__c FROM Opportunity WHERE Id =:pageid LIMIT 1].Name;
        box.Toolkit toolKit = new box.Toolkit();
    //レコード紐づけフォルダのIDを取得する    
        String pagefolderid = toolKit.getFolderIdByRecordId(pageid);
        if(Test.isRunningTest()==true){
            pagefolderid = 'thisIsATest';
            this.feedback = System.label.Box_CustomError2;
             this.feedbackOK = System.label.Box_CustomError2;
        }
        else{
            if(pagefolderid==null){
            	this.feedback = System.label.Box_CustomError2;
            	return null;
        	}              
        }
		system.debug('フォルダIDは' + pagefolderid); 
      
    //テンプレートフォルダ　XXX_AccountTemplateのコールアウト設定：endpoint
        String endpoint1 = 'https://api.box.com/2.0/folders/' + '168048136853' + '/copy'; //資料テンプレート
    
    //body:json部分を構築、httpリクエストを送信(コピー)
        HttpRequest requestcopy = new HttpRequest();
        requestcopy.setMethod('POST');                 
        BoxFolder.Info parent = new BoxFolder.Info();
        parent.addValue('id', pagefolderid);       
        BoxFolder.Info copyInfo = new BoxFolder.Info();
        copyInfo.addValue('parent', parent.getJsonString());
        requestcopy.setBody(copyInfo.getJsonString());
        requestcopy.setHeader('content-type', 'application/json');

		requestcopy.setEndpoint(endpoint1);  
        HttpResponse response1 = toolKit.sendRequest(requestcopy);
        system.debug('response1' + response1);

	//フォルダの移動、社内取引先の保管先フォルダのIDはBernersCore166362927157とします。
	    //取引先フォルダは作成済みかの確認       
        try{
        String nameOfAccount = [SELECT Id,AccountId FROM Opportunity WHERE Id =:pageid LIMIT 1].AccountId;
        System.debug('nameOfAccount:' + nameOfAccount);
        String accountFolderID = toolKit.getFolderIdByRecordId(nameOfAccount);
        if(Test.isRunningTest()==true){
            nameOfAccount = 'thisIsATest';
			accountFolderID= 'thisIsATest';
        }
          	If(accountFolderID==null){
            		this.feedback = System.label.Box_CustomError4;	
                	return null;
        	}
        }
		catch (Exception NoAccountFolderError){
                this.feedback = NoAccountFolderError.getMessage();
            	return null;
        }        
        String nameOfAccount = [SELECT Id,AccountId FROM Opportunity WHERE Id =:pageid LIMIT 1].AccountId;
        
        System.debug('nameOfAccount:' + nameOfAccount);
        String accountFolderID = toolKit.getFolderIdByRecordId(nameOfAccount);
        
        System.debug('accountFolderID:' + accountFolderID);
          if(Test.isRunningTest()==true){
            nameOfAccount = 'thisIsATest';
			accountFolderID= 'thisIsATest';
        }
		//目標フォルダ項目のリストを取得
   		HttpRequest requestList = new HttpRequest();
        requestList.setMethod('GET');                 
        requestList.setHeader('content-type', 'application/json');
		requestList.setEndpoint('https://api.box.com/2.0/folders/' + accountFolderID + '/items');
		HttpResponse responseList = toolKit.sendRequest(requestList);
        String decoding;
		if(Test.isRunningTest()==true){
            decoding = '{ "total_count": 3, "entries": [ { "id": "16839", "name": "情報" }, { "id": "16839", "name": "商談情報" }, { "id": "16839", "name": "情報" } ], "order": [ { "by": "name", "direction": "ASC" } ] }';
        }
        else{
            decoding = responseList.getBody();
        }	
        //json解析
        Map<String, Object> mapResponseData;
        List<Object> dataToResults;
        if(Test.isRunningTest()==true){
           
           mapResponseData = (Map<String, Object>)Json.deserializeUntyped(decoding);
        }
        else{
            mapResponseData = (Map<String, Object>)Json.deserializeUntyped(decoding);
			system.debug('mapResponseData::' + mapResponseData);            
        }
        dataToResults = (List<Object>)mapResponseData.get('entries');  
       	system.debug('dataToResults::'+dataToResults);
        if(dataToResults.size()==0){
                         this.feedback = System.label.Box_CustomError4;
                         return null;
                     }        
        Integer i = 0;
         while ((String)((Map<String, Object>)dataToResults[i]).get('name') != '商談情報') {
 					i++;
                     if(i > (dataToResults.size()-1)){
                         this.feedback = System.label.Box_CustomError4;
                         return null;
                     }
            }			
        String OppFolderID = (String)((Map<String, Object>)dataToResults[i]).get('id');
        system.debug('OppFolderID::'+OppFolderID);
        system.debug(dataToResults.size());        
		system.debug(decoding);        
		Boolean result1 = toolKit.moveFolder(pagefolderid, OppFolderID, null); 
    
    //リネーム前処理
    	renamename = renamename.replace('/', '／');
        renamename = renamename.replace('\\', '＼');
    //リネームリクエストのbody:json部分を構築
		HttpRequest requestrename = new HttpRequest();
        requestrename.setMethod('PUT');
        BoxFolder.Info foldername = new BoxFolder.Info();
        foldername.addValue('name', renameid + '_' + renamename);
        requestrename.setBody(foldername.getJsonString());
        requestrename.setHeader('content-type', 'application/json');
        requestrename.setEndpoint('https://api.box.com/2.0/folders/' + pagefolderid);
        
    //httpリクエストを送信(リネーム)
        HttpResponse response4 = toolKit.sendRequest(requestrename);
        system.debug('response4' + response4);
        Boolean result4;
        
      if(Test.isRunningTest()==true){

          result4 = true;         
        }
        else{
        result4 = response4.toString().contains('20');
        system.debug('result4' + result4);            
        }
        
        if((result4==true)&&(result1==true)){
            this.feedbackOK = System.label.Box_Custom1;
        }
        else{
            this.feedback = System.label.Box_CustomError3;
    }  
       	return null;
    }
   
}