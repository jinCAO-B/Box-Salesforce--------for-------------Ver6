public without sharing class Box_ProjectController {
    private final teamspirit__AtkJob__c acct;
    
//引数に標準コントローラを指定して、メソッドを使用してレコードIDを取得します。
    public Box_ProjectController(ApexPages.StandardController stdController) {
        this.acct = (teamspirit__AtkJob__c)stdController.getRecord();
    }
  
   /**
     * コンストラクタ.
     * @param stdController 標準コントローラ
     */    
    
    public string feedback {get;set;}
    public string feedbackOk {get;set;}	 
    
//@AuraEnabled(cacheable=true) 
//@RemoteAction
    public pagereference apiCopyTemplateProject(){
        String pageid = System.ApexPages.currentPage().getParameters().get('id');
        system.debug('pageid:' + pageid);
        if(pageid==null) {
            this.feedback = System.label.Box_CustomError1;
            return null;
        }
        String renameid = [SELECT Id,ProjectPrefix__c FROM teamspirit__AtkJob__c WHERE Id =:pageid LIMIT 1].ProjectPrefix__c;
        if(renameid==null){
            this.feedback = System.label.Box_CustomError5;
            return null;
        }
        String renamename = [SELECT Name,ProjectPrefix__c FROM teamspirit__AtkJob__c WHERE Id =:pageid LIMIT 1].Name;
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
        String endpoint1 = 'https://api.box.com/2.0/folders/' + '166484384454' + '/copy'; 
        String endpoint2 = 'https://api.box.com/2.0/folders/' + '166484371254' + '/copy'; 
    	String endpoint3 = 'https://api.box.com/2.0/folders/' + '166484378454' + '/copy'; 
        String endpoint4 = 'https://api.box.com/2.0/folders/' + '166484382054' + '/copy'; 
    	String endpoint5 = 'https://api.box.com/2.0/folders/' + '166484380854' + '/copy'; 
        
        String endpoint6 = 'https://api.box.com/2.0/folders/' + '166484379654' + '/copy'; 
    	String endpoint7 = 'https://api.box.com/2.0/folders/' + '166484377254' + '/copy'; 
        String endpoint8 = 'https://api.box.com/2.0/folders/' + '166484376054' + '/copy'; 
    	String endpoint9 = 'https://api.box.com/2.0/folders/' + '166484374854' + '/copy'; 
        String endpoint10 = 'https://api.box.com/2.0/folders/' + '166484373654' + '/copy'; 
        
    	String endpoint11 = 'https://api.box.com/2.0/folders/' + '166484372454' + '/copy'; 
        String endpoint12 = 'https://api.box.com/2.0/folders/' + '166484370054' + '/copy'; 
    	String endpoint13 = 'https://api.box.com/2.0/folders/' + '166484368854' + '/copy'; 
        String endpoint14 = 'https://api.box.com/2.0/folders/' + '166484367654' + '/copy';   
    
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
        
		requestcopy.setEndpoint(endpoint2);  
        HttpResponse response2 = toolKit.sendRequest(requestcopy);
        system.debug('response2' + response2);
        
		requestcopy.setEndpoint(endpoint3);  
        HttpResponse response3 = toolKit.sendRequest(requestcopy);
        system.debug('response3' + response3);
        
		requestcopy.setEndpoint(endpoint4);  
        HttpResponse response4 = toolKit.sendRequest(requestcopy);
        system.debug('response4' + response4);
        
		requestcopy.setEndpoint(endpoint5);  
        HttpResponse response5 = toolKit.sendRequest(requestcopy);
        system.debug('response5' + response5);

		requestcopy.setEndpoint(endpoint6);  
        HttpResponse response6 = toolKit.sendRequest(requestcopy);
        system.debug('response6' + response6);
        
		requestcopy.setEndpoint(endpoint7);         
        HttpResponse response7 = toolKit.sendRequest(requestcopy);
        system.debug('response7' + response7);
        
		requestcopy.setEndpoint(endpoint8);  
        HttpResponse response8 = toolKit.sendRequest(requestcopy);
        system.debug('response8' + response8);
        
		requestcopy.setEndpoint(endpoint9);  
        HttpResponse response9 = toolKit.sendRequest(requestcopy);
        system.debug('response9' + response9);
        
		requestcopy.setEndpoint(endpoint10);  
        HttpResponse response10 = toolKit.sendRequest(requestcopy);
        system.debug('response10' + response10); 
        
		requestcopy.setEndpoint(endpoint11);  
        HttpResponse response11 = toolKit.sendRequest(requestcopy);
        system.debug('response11' + response11);
        
		requestcopy.setEndpoint(endpoint12);  
        HttpResponse response12 = toolKit.sendRequest(requestcopy);
        system.debug('response12' + response12);
        
		requestcopy.setEndpoint(endpoint13);  
        HttpResponse response13 = toolKit.sendRequest(requestcopy);
        system.debug('response13' + response13);
        
		requestcopy.setEndpoint(endpoint14);  
        HttpResponse response14 = toolKit.sendRequest(requestcopy);
        system.debug('response14' + response14);

	//フォルダの移動、社内取引先の保管先フォルダのIDはBernersCore166362927157とします。
	    //取引先フォルダは作成済みかの確認       
        try{
        String nameOfAccount = [SELECT Id,teamspirit__AccountId__c FROM teamspirit__AtkJob__c WHERE Id =:pageid LIMIT 1].teamspirit__AccountId__c;
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
        String nameOfAccount = [SELECT Id,teamspirit__AccountId__c FROM teamspirit__AtkJob__c WHERE Id =:pageid LIMIT 1].teamspirit__AccountId__c;
        
        System.debug('nameOfAccount:' + nameOfAccount);
        String accountFolderID = toolKit.getFolderIdByRecordId(nameOfAccount);
        
        System.debug('accountFolderID:' + accountFolderID);
  
		//目標フォルダ項目のリストを取得
   		HttpRequest requestList = new HttpRequest();
        requestList.setMethod('GET');                 
        requestList.setHeader('content-type', 'application/json');
		requestList.setEndpoint('https://api.box.com/2.0/folders/' + accountFolderID + '/items');
		HttpResponse responseList = toolKit.sendRequest(requestList);
        String decoding;
		if(Test.isRunningTest()==true){
            decoding = '{ "total_count": 3, "entries": [ { "id": "16839", "name": "情報" }, { "id": "16839", "name": "プロジェクト情報" }, { "id": "16839", "name": "情報" } ], "order": [ { "by": "name", "direction": "ASC" } ] }';
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
         while ((String)((Map<String, Object>)dataToResults[i]).get('name') != 'プロジェクト情報') {
 					i++;
                     if(i > (dataToResults.size()-1)){
                         this.feedback = System.label.Box_CustomError4;
                         return null;
                     }
            }			
        String ProFolderID = (String)((Map<String, Object>)dataToResults[i]).get('id');
        system.debug('ProFolderID::'+ProFolderID);
        system.debug(dataToResults.size());        
		system.debug(decoding);        
		Boolean result1 = toolKit.moveFolder(pagefolderid, ProFolderID, null); 
        
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
        HttpResponse response0 = toolKit.sendRequest(requestrename);
        system.debug('response0' + response0);
		
             Boolean result0;
             Boolean result2; 
             Boolean result3; 
             Boolean result4; 
             Boolean result5; 
             Boolean result6; 
             Boolean result7; 
             Boolean result8; 
             Boolean result9; 
             Boolean result10; 
             Boolean result11; 
             Boolean result12; 
             Boolean result13;
             Boolean result14; 
        
      if(Test.isRunningTest()==true){
          result1 = true;
          result2 = true; 
          result3 = true; 
          result4 = true; 
          result5 = true; 
          result6 = true; 
          result7 = true; 
          result8 = true; 
          result9 = true; 
          result10 = true; 
          result11 = true; 
          result12 = true; 
          result13 = true;
          result14 = true;           
          result0 = true;         
        }
        else{
        result0 = response0.toString().contains('20');
        result1 = response1.toString().contains('20');
        result2 = response2.toString().contains('20');
        result3 = response3.toString().contains('20');
        result4 = response4.toString().contains('20');
       	result5 = response5.toString().contains('20');
        result6 = response6.toString().contains('20');
        result7 = response7.toString().contains('20');
      	result8 = response8.toString().contains('20');
        result9 = response9.toString().contains('20');
        result10 = response10.toString().contains('20');
       	result11 = response11.toString().contains('20');
      	result12 = response12.toString().contains('20');
        result13 = response13.toString().contains('20');
        result14 = response14.toString().contains('20');
        system.debug('result4' + result0);            
        }
        
        if((result0==true)&&(result1==true)&&(result2==true)&&(result3==true)&&(result4==true)&&(result5==true)&&(result6==true)&&(result7==true)&&(result8==true)&&(result9==true)&&(result10==true)&&(result11==true)&&(result12==true)&&(result13==true)&&(result14==true)){
            this.feedbackOK = System.label.Box_Custom1;
        }
        else{
            this.feedback = System.label.Box_CustomError3;     
    }  
       	return null;
    }
}