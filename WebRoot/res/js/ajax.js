// 生成文件
function doAjaxFileDownload(url, data) {
    doAjaxSubmit("post", url, data, "doAjaxFileDownloadSuccess");
};
// 文件下载
function doAjaxFileDownloadSuccess(data) {
    var messageInfos = makeServerMessage(data);
    if (messageInfos != null ) {
        showMessage(messageInfos);
    }else{
    	var url = rootPath + '/do/act_common/m_doAjaxFileDownload?rand' + Math.random();
    	var form = $('<form action="' + url + '" method="POST"></form>');
    	var filePath = $('<input type="hidden" name="filePath" value="' + data.filePath + '"/>');
    	var fileName = $('<input type="hidden" name="fileName" value="' + data.fileName + '"/>');
    	filePath.appendTo(form);
    	fileName.appendTo(form);
    	form.appendTo("body");
    	form.css('display','none');
    	$(form).submit();
    	$(form).remove();
    }
};


//共通提交用的方法。
//注：共通内部使用，没有特殊原因，各机能不能直接调用
function doCommonSubmit(type, url, data, success) {
    $.ajax({
        type: type,
        url: url,
        data: data,
        beforeSend: function(XMLHttpRequest) {//发送前 
        	layer.load();
        },
        success: function(response){
            var messageInfos = [];
            var errorMsg;
            if (response.hasOwnProperty("errList") == false){
            	layer.closeAll();
            	layer.msg("操作完成！");
            }else if (success != null && success != '') {
            	layer.closeAll();
                //执行自定义回调函数
                eval(success)(response);
            }
        },
        error: function(e){
            // popAlert(getMessageFromList("ME00107", null));
            // alert('Error: ' + e);
        },
        complete: function(e){
        }
    });
}

//注意：共通和各个机能都可以调用。
function doAjaxSubmit(httpmethod,url,data,success){
	if (data != null) {
		if (typeof(parent.loginCredential) != 'undefined') {
			data['loginCredential'] = parent.loginCredential;
		} else if (typeof(loginCredential) != 'undefined') {
			data['loginCredential'] = loginCredential;
		}
	}
    doCommonSubmit(httpmethod, url,data,success);
}

//异步文件上传方法
//name->上传文件控件名称
//url->请求提交路
//indata->提交的数据
//callback->回调函数
function ajaxFileUpload(name,url,indata,callback){

    if(($("#"+name)).length > 0){
    	if (indata != null) {
    		if (typeof(parent.loginCredential) != 'undefined') {
    			indata['loginCredential'] = parent.loginCredential;
    		} else if (typeof(loginCredential) != 'undefined') {
    			indata['loginCredential'] = loginCredential;
    		}
    	}
        $.ajaxFileUpload(
            {
            //需要链接到服务器地址
             url:url,
             //secureuri:false,
             //文件选择框的id属性
             fileElementId:name,
             data: indata,
             type:"post",
             //服务器返回的格式，可以是json
             dataType: 'json',
             //相当于java中try语句块的用法
             beforeSend: function(XMLHttpRequest) {//发送前
            	 layer.load();
             },
             success: function (data, status){
            	 layer.closeAll();
                 if (callback != null && callback != '') {
                        //执行自定义回调函数
                        eval(callback)(data);
                    }
             },
             //相当于java中catch语句块的用法
             error: function (data, status, e){
            	// removecloud();
                // popAlert(getMessageFromList("ME00108", null));
             }
            }
        );
    }else{
       // popAlert(getMessageFromList("上传失败", null));
    }
}

