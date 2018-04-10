<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html >
<html lang="zh-CN">
<head>
    <jsp:include page="public/base.jsp"/>
    <link rel="stylesheet" href="${_basePath}static/css/jquery.jsonview.min.css?v=${_jsvesion}">
    <script type="text/javascript" src="${_basePath}static/js/jquery.jsonview.min.js?v=${_jsvesion}"></script>
    <style type="text/css">
        html, body, #app, .layout {
            height: 100%;
        }

        .line-margin {
            margin-bottom: 8px;
        }
    </style>
</head>
<body>
<div id="app">
    <div class="layout" style="padding: 0 5px 0 5px">
        <row type="flex" align="middle" class="line-margin">
            <i-col span="10">
                <i-input id="el_input_name" size="small" placeholder="例:获取省列表" type="text" :value='details.inName'>
                    <span slot="prepend">请求接口:</span>
                    <span @click="onClearNameBtnClickListener" slot="append">清除</span>
                </i-input>
            </i-col>
            <i-col span="2" offset="6">
                <i-button @click="onSendBtnClickListener" type="primary" size="small">接口发送</i-button>
            </i-col>
            <i-col span="2">
                <i-button @click="onAddParmaBtnClickListener" type="success" size="small">增加参数</i-button>
            </i-col>
            <i-col span="2">
                <i-button @click="onSaveDataBtnClickListener" type="info" size="small">保存接口</i-button>
            </i-col>
            <i-col span="2">
                <i-button @click="onDeleteDocBtnClickListener" type="error" size="small">删除接口</i-button>
            </i-col>
        </row>
        <row type="flex" align="middle" class="line-margin">
            <i-col span="20">
                <i-input id="el_input_url" size="small" placeholder="例:https://xxx/xxx.do" type="text"
                         :value='details.inUrl'>
                    <span slot="prepend">接口路径:</span>
                    <span @click="onClearUrlBtnClickListener" slot="append">清除</span>
                </i-input>
            </i-col>
        </row>
        <row v-for="(paramItem,index) in params" class="line-margin itemInputContent">
            <i-col span="5">
                <i-input class="itemInputkey" size="small" placeholder="例:city_id" type="text" :value='paramItem.paKey'>
                    <span slot="prepend">参数&nbspkey&nbsp:</span>
                </i-input>
            </i-col>
            <i-col span="5">
                <i-input class="itemInputValue" size="small" placeholder="例:0" type="text" :value='paramItem.paValue'>
                    <span slot="prepend">参数value:</span>
                </i-input>
            </i-col>
            <i-col span="10">
                <i-input class="itemInputExample" size="small" placeholder="选填" type="text"
                         :value='paramItem.paExample'>
                    <span slot="prepend">参数说明:</span>
                </i-input>
            </i-col>
            <i-col span="2" offset="2">
                <i-button @click="onDeleteParmaItemClickListener(paramItem,index)" type="warning" size="small">删除参数
                </i-button>
            </i-col>
        </row>
        <row class="line-margin">
            <i-col span="23">
                <card>
                    <div slot="title">
                        <row>
                            <i-col span="10">
                                <p>请求结果:</p>
                            </i-col>
                            <i-col span="8" offset="6">
                                <i-button @click="onCopyResponseClickListener" size="small">复制结果</i-button>
                                <i-button @click="onChangeResponseClickListener" size="small">收缩数组</i-button>
                                <i-button @click="onSetResponseOkClickListener" size="small">设为成功示例</i-button>
                                <i-button @click="onSetResponseErrClickListener" size="small">设为失败示例</i-button>
                            </i-col>
                        </row>
                    </div>
                    <div id="ajax_response"></div>
                </card>
            </i-col>
        </row>
        <row class="line-margin">
            <i-col span="11">
                <card>
                    <div slot="title">
                        <row>
                            <i-col span="6">
                                <p>请求成功示例:</p>
                            </i-col>
                            <i-col span="18">
                                <i-button @click="onCopyResOkClickListener" size="small">复制结果</i-button>
                                <i-button @click="onChangeResOkClickListener" size="small">收缩数组</i-button>
                            </i-col>
                        </row>
                    </div>
                    <div id="ajax_ok"></div>
                </card>
            </i-col>
            <i-col span="11" offset="1">
                <card>
                    <div slot="title">
                        <row>
                            <i-col span="6">
                                <p>请求失败示例:</p>
                            </i-col>
                            <i-col span="18">
                                <i-button @click="onCopyResErrClickListener" size="small">复制结果</i-button>
                                <i-button @click="onChangeResErrClickListener" size="small">收缩数组</i-button>
                            </i-col>
                        </row>
                    </div>
                    <div id="ajax_err"></div>
                </card>
            </i-col>
        </row>
        <Modal v-model="is_showDialog" :title='dialogTitle'>{{dialogContent}}</Modal>
    </div>
</div>
<script type="text/javascript">
    var mApp = new Vue({
        el: '#app',
        data: {
            fo_id: '',
            in_id: '',
            details: {},
            params: [{}],
            dialogTitle: '温馨提示',
            dialogContent: '',
            is_showDialog: false
        },
        components: {},
        computed: {},
        methods: {
            showToast: function (content, type) {
                if (type !== 0) {
                    this.$Notice.success({
                        title: "操作成功",
                        desc: content
                    });
                } else {
                    this.$Notice.error({
                        title: mApp.dialogTitle,
                        desc: content
                    });
                }
            },
            get_details: function () {
                $.post(basePath + "interface/getDetail", {in_id: mApp.in_id},
                    function (response) {
                        if (response.status === 0) {
                            if (response.data) {
                                mApp.details = response.data;
                                mApp.get_params();
                                mApp.get_responses();
                            }
                        } else {
                            mApp.showToast(response.msg, 0);
                        }
                    }, 'json');
            },
            get_params: function () {
                $.post(basePath + "interface/getParams", {in_id: mApp.in_id},
                    function (response) {
                        if (response.status === 0) {
                            if (response.data) {
                                mApp.params = response.data;
                            }
                        } else {
                            mApp.showToast(response.msg, 0);
                        }
                    }, 'json');
            },
            get_responses: function () {
                var dataOK = mApp.details.inResponseOk;
                if (dataOK) {
                    $('#ajax_ok').JSONView(dataOK, {collapsed: true});
                    $('#ajax_ok').data(JSON.parse(dataOK));
                }
                var dataErr = mApp.details.inResponseErr;
                if (dataErr) {
                    $('#ajax_err').JSONView(dataErr, {collapsed: false});
                    $('#ajax_err').data(JSON.parse(dataErr));
                }
            },
            get_sendResponse: function () {
                var requestJson = '{"requestUrl":"' + mApp.details.inUrl + '"';
                $.each(mApp.params, function (index, item) {
                    var key = item.paKey;
                    var value = item.paValue;
                    if (!isEmpty(key)) {
                        requestJson += ',"' + key + '":"' + value + '"';
                    }
                });
                requestJson += '}';
                console.info(requestJson);
                $.post(basePath + "interface/getSendResponse", JSON.parse(requestJson),
                    function (response) {
                        console.info(JSON.stringify(response));
                        innerStorage.set('response', response);
                        $('#ajax_response').JSONView(response);
                    }, 'json');
            },
            onClearNameBtnClickListener: function () {
                $('#el_input_name input').val('');
            },
            onClearUrlBtnClickListener: function () {
                $('#el_input_url input').val('');
            },
            onSendBtnClickListener: function () {
                mApp.updatePageData();
                if (isEmpty(mApp.details.inUrl)) {
                    mApp.showToast('请填url', 0);
                    return;
                }
                mApp.get_sendResponse();
            },
            onAddParmaBtnClickListener: function () {
                mApp.params.push({});
            },
            onSaveDataBtnClickListener: function () {
                mApp.updatePageData();
                if (isEmpty(mApp.details.inName)) {
                    mApp.showToast('请填写接口名', 0);
                    return;
                }
                if (isEmpty(mApp.details.inUrl)) {
                    mApp.showToast('请填接口url', 0);
                    return;
                }
                mApp.startSave();
            },
            onDeleteDocBtnClickListener: function () {
                $.post(basePath + "interface/deleteDoc", {
                        in_id: mApp.in_id
                    },
                    function (response) {
                        if (response.status === 0) {
                            mApp.in_id = 0;
                            mApp.details = {};
                            mApp.params = [];
                            mApp.clearPageData();
                            mApp.showToast("删除成功!");
                        } else {
                            mApp.showToast(response.msg, 0);
                        }
                    }, 'json');
            },
            onDeleteParmaItemClickListener: function (paramItem, index) {
                removeByValue(mApp.params, paramItem);
            },
            onCopyResponseClickListener: function () {
                copyToClipboard(innerStorage.get('response'));
            },
            onChangeResponseClickListener: function () {
                $('#ajax_response').JSONView('toggle');
            },
            onSetResponseOkClickListener: function () {
                var response = innerStorage.get('response');
                var strData = JSON.stringify(response);
                if (strData.length > 4) {
                    $('#ajax_ok').data(response).JSONView(response, {collapsed: true});
                    mApp.showToast("设置为成都示例成功");
                } else {
                    mApp.showToast("设置失败,请求结果为空", 0);
                }
            },
            onSetResponseErrClickListener: function () {
                var response = innerStorage.get('response');
                var strData = JSON.stringify(response);
                if (strData.length > 4) {
                    $('#ajax_err').data(response).JSONView(response, {collapsed: true});
                    mApp.showToast("设置为失败示例成功");
                } else {
                    mApp.showToast("设置失败,请求结果为空", 0);
                }
            },
            onCopyResOkClickListener: function () {
                copyToClipboard($('#ajax_ok').data());
            },
            onCopyResErrClickListener: function () {
                copyToClipboard($('#ajax_err').data());
            },
            onChangeResOkClickListener: function () {
                $('#ajax_ok').JSONView('toggle');
            },
            onChangeResErrClickListener: function () {
                $('#ajax_err').JSONView('toggle');
            },
            updatePageData: function () {
                var arrParma = [];
                $.each($('.itemInputContent'), function (index, item) {
                    var key = $(item).find('.itemInputkey input').val();
                    var value = $(item).find('.itemInputValue input').val();
                    var example = $(item).find('.itemInputExample input').val();
                    arrParma.push({
                        paKey: key,
                        paValue: value,
                        paExample: example
                    });
                });
                mApp.params = arrParma;
                mApp.details.inResponseOk = JSON.stringify($('#ajax_ok').data());
                mApp.details.inResponseErr = JSON.stringify($('#ajax_err').data());
                mApp.details.inName = $('#el_input_name input').val();
                mApp.details.inUrl = $('#el_input_url input').val();
            },
            clearPageData: function () {
                $('#el_input_name input').val('');
                $('#el_input_url input').val('');
                $('#ajax_ok').JSONView({}, {collapsed: true});
                $('#ajax_err').JSONView({}, {collapsed: true});
            },
            startSave: function () {
                $.post(basePath + "interface/saveInterface", {
                        fo_id: mApp.fo_id,
                        in_id: mApp.in_id,
                        in_url: mApp.details.inUrl,
                        in_name: mApp.details.inName,
                        in_response_ok: mApp.details.inResponseOk,
                        in_response_err: mApp.details.inResponseErr,
                        params: JSON.stringify(mApp.params)
                    },
                    function (response) {
                        if (response.status === 0) {
                            mApp.showToast('保存成功');
                        } else {
                            mApp.showToast(response.msg, 0);
                        }
                    }, 'json');
            }
        },
        created: function () {
            setTimeout(function () {
                mApp.in_id = innerStorage.get('in_id');
                mApp.fo_id = innerStorage.get('fo_id');
                mApp.get_details();
            }, 200);
        }
    });

    function copyToClipboard(str) {
        // 创建元素用于复制
        var aux = document.createElement("input");
        // 获取复制内容
        var content = JSON.stringify(str);
        // 设置元素内容
        aux.setAttribute("value", content);
        // 将元素插入页面进行调用
        document.body.appendChild(aux);
        // 复制内容
        aux.select();
        // 将内容复制到剪贴板
        document.execCommand("copy");
        // 删除创建元素
        document.body.removeChild(aux);
        mApp.showToast("复制成功");
    }
</script>
</body>
</html>
