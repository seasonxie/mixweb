<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html >
<html lang="zh-CN">
<head>
    <jsp:include page="public/base.jsp"/>
    <style type="text/css">
        html, body, #app, #root {
            width: 100%;
            height: 100%;
        }

        .msgContent {
            background: #eee;
            padding: 10px;
            border-radius: 15px;
        }

        .line {
            height: 8px;
        }

        .showMaxWid {
            width: 100%;
        }
    </style>
</head>
<body>
<div id="app">
    <row id="root" type="flex" justify="center" align="middle">
        <i-col class="msgContent" span="9">
            <div class="msgContent">
                <card :bordered="false">
                    <p slot="title">${_projectTitle}</p>
                    <row>
                        <i-col span="24">
                            <i-input id="el_input_phone" size="small" placeholder="13800138000" type="text">
                                <span slot="prepend">手机号:</span>
                            </i-input>
                        </i-col>
                    </row>
                    <div class="line"></div>
                    <row>
                        <i-col span="24">
                            <i-input id="el_input_pass1" size="small" placeholder="******" type="password">
                                <span slot="prepend">密&nbsp&nbsp&nbsp&nbsp码:</span>
                            </i-input>
                        </i-col>
                    </row>
                    <div v-if="is_regist" class="line"></div>
                    <row v-if="is_regist">
                        <i-col span="24">
                            <i-input id="el_input_pass2" size="small" placeholder="******" type="password">
                                <span slot="prepend">密&nbsp&nbsp&nbsp&nbsp码:</span>
                            </i-input>
                        </i-col>
                    </row>
                   <%-- <div class="line"></div>
                    <row>
                        <i-col span="16">
                            <i-input id="el_input_yzimg" size="small" type="text">
                                <span slot="prepend">验证码:</span>
                            </i-input>
                        </i-col>
                        <i-col span="6" offset="2">
                            <i-button :loading="is_loading" class="showMaxWid" size="small" @click="get_yzText">
                                <span v-if="!is_loading">{{yzText}}</span>
                                <span v-else></span>
                            </i-button>
                        </i-col>
                    </row>--%>
                    <div class="line"></div>
                    <div class="line"></div>
                    <div class="line"></div>
                    <row v-if="!is_regist">
                        <i-col span="16">
                            <i-button size="small" @click="on_defult">游客登陆</i-button>
                            <i-button size="small" @click="on_changeRegist">立即注册</i-button>
                            <i-button size="small" @click="on_forget">找回密码</i-button>
                        </i-col>
                        <i-col span="6" offset="2">
                            <i-button class="showMaxWid" size="small" @click="on_login">登&nbsp&nbsp&nbsp&nbsp陆
                            </i-button>
                        </i-col>
                    </row>
                    <row v-if="is_regist" type="flex" justify="center" align="middle">
                        <i-col span="10">
                            <i-button class="showMaxWid" size="small" @click="on_changeLogin">返回登陆</i-button>
                        </i-col>
                        <i-col span="10" offset="4">
                            <i-button class="showMaxWid" size="small" @click="on_regist">注&nbsp&nbsp&nbsp&nbsp册
                            </i-button>
                        </i-col>
                    </row>
                </card>
            </div>
        </i-col>
    </row>
    <Modal v-model="is_showDialog" :title='dialogTitle'>{{dialogContent}}</Modal>
</div>
<script>
    var mApp = new Vue({
        el: '#app',
        data: {
            yzText: '',
            dialogTitle: '温馨提示',
            dialogContent: '',
            is_loading: true,
            is_showDialog: false,
            is_regist: false
        },
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
            get_yzText: function () {
                mApp.is_loading = true;
                setTimeout(function () {
                    $.post(basePath + 'user/getRandemStr', {}, function (response) {
                        if (response.status === 0) {
                            mApp.yzText = response.data;
                            mApp.is_loading = false;
                        } else {
                            mApp.showToast(response.msg, 0);
                        }
                    }, 'json');
                }, 500);
            },
            on_changeRegist: function () {
                mApp.is_regist = true;
                setTimeout(function () {
                    $('#el_input_pass1 input').val('');
                    $('#el_input_pass2 input').val('');
                   // $('#el_input_yzimg input').val('');
                }, 300);
            },
            on_changeLogin: function () {
                mApp.is_regist = false;
                setTimeout(function () {
                    $('#el_input_pass1 input').val('');
                    $('#el_input_pass2 input').val('');
                  //  $('#el_input_yzimg input').val('');
                }, 300);
            },
            on_forget: function () {
                mApp.dialogContent = '不支持找回密码,若需要请联系QQ:200676087(小明)';
                mApp.is_showDialog = true;
            },
            on_defult: function () {
                mApp.requestData(0);
            },
            on_regist: function () {
                mApp.requestData(1);
            },
            on_login: function () {
                mApp.requestData(2);
            },
            requestData: function (type) {
                var phone = type === 0 ? '13800138000' : $('#el_input_phone input').val();
                var pass1 = type === 0 ? '13800138000' : $('#el_input_pass1 input').val();
                var pass2 = type === 0 ? '13800138000' : $('#el_input_pass2 input').val();
               // var yzimg = type === 0 ? mApp.yzText : $('#el_input_yzimg input').val();
                if (isEmpty(phone) || phone.length != 11) {
                    mApp.showToast('请输入正确的手机号', 0);
                    return
                }
               /* if (isEmpty(yzimg)) {
                    mApp.showToast('验证码不能为空', 0);
                    return
                }*/
                if (isEmpty(pass1) || pass1.length < 6) {
                    mApp.showToast('密码要六位以上哟', 0);
                    return
                }
               /* if (yzimg != mApp.yzText) {
                    mApp.showToast('验证码有误', 0);
                    return
                }*/
                if (mApp.is_regist) {
                    if (pass1 != pass2) {
                        mApp.showToast('两次密码不同', 0);
                        return
                    }
                }
                top.location.href = basePath + "views/sysHome.jsp";

           /*     var reuqetUrl = type === 1 ? 'user/sysRegist' : 'user/sysLogin';
                $.post(basePath + reuqetUrl, {
                    phone: phone,
                    pass: pass1
                    //yzimg: yzimg
                }, function (response) {
                    if (response.status === 0) {
                        top.location.href = basePath + "home";
                    } else {
                        mApp.showToast(response.msg, 0);
                    }
                }, 'json');*/
            }
        },
        created: function () {
         /*   setTimeout(function () {
                mApp.get_yzText();
            }, 500);*/
        }
    })
</script>
</body>
</html>
