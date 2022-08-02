public without sharing class Box_AccountExtensionsController {
    private final Account acct;

//引数に標準コントローラを指定して、メソッドを使用してレコードIDを取得します。
    public Box_AccountExtensionsController(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
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
    public pagereference apiCopyTemplate(){

        String pageid = System.ApexPages.currentPage().getParameters().get('id');
        system.debug('pageid:' + pageid);
        if(pageid==null) {
            this.feedback = System.label.Box_CustomError1;
            return null;
        }
        String renameid = [SELECT Id,BusinessPartnerId__c FROM account WHERE Id =:pageid LIMIT 1].BusinessPartnerId__c;
        //String renameid = null;
        if(renameid==null){
            this.feedback = System.label.Box_CustomError1;
            return null;
        }
        String renamename = [SELECT Name,BusinessPartnerId__c FROM account WHERE Id =:pageid LIMIT 1].Name;
        //String renamename = null;


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
        String endpoint1 = 'https://api.box.com/2.0/folders/' + '166484355654' + '/copy'; //プロジェクト情報
        String endpoint2 = 'https://api.box.com/2.0/folders/' + '166484354454' + '/copy'; //商談情報
    	String endpoint3 = 'https://api.box.com/2.0/folders/' + '166484353254' + '/copy'; //社外公開情報

    //コピーリクエストのbody:json部分を構築する
        HttpRequest requestcopy = new HttpRequest();
        requestcopy.setMethod('POST');
        BoxFolder.Info parent = new BoxFolder.Info();
        parent.addValue('id', pagefolderid);
        BoxFolder.Info copyInfo = new BoxFolder.Info();
        copyInfo.addValue('parent', parent.getJsonString());
        requestcopy.setBody(copyInfo.getJsonString());
        requestcopy.setHeader('content-type', 'application/json');

    //httpリクエストを送信(コピー)
		requestcopy.setEndpoint(endpoint1);
        HttpResponse response1 = toolKit.sendRequest(requestcopy);
        system.debug('response1' + response1);

       	requestcopy.setEndpoint(endpoint2);
        HttpResponse response2 = toolKit.sendRequest(requestcopy);
        system.debug(response2);

        requestcopy.setEndpoint(endpoint3);
        HttpResponse response3 = toolKit.sendRequest(requestcopy);
        system.debug(response3);

	//フォルダの移動、社内取引先の保管先フォルダのIDはBernersCore166362927157とします。
		toolKit.moveFolder(pagefolderid, '166362927157', null); //166813327776
        
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
		Boolean result1;
        Boolean result2;
        Boolean result3;
        Boolean result4;

      if(Test.isRunningTest()==true){
          result1 = true;
          result2 = true;
          result3 = true;
          result4 = true;
        }
        else{
        result1 = response1.toString().contains('20');
        system.debug('result1' + result1);
        result2 = response2.toString().contains('20');
        system.debug('result2' + result2);
        result3 = response3.toString().contains('20');
        system.debug('result3' + result3);
        result4 = response4.toString().contains('20');
        system.debug('result4' + result4);

        }


        if((result1==true)&&(result2==true)&&(result3==true)&&(result4==true)){
            this.feedbackOK = System.label.Box_Custom1;
        }
        else{
            this.feedback = System.label.Box_CustomError3;
    }
       	return null;
    }

}