<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html >
<html lang="zh-CN">
<head>
    <jsp:include page="public/base.jsp"/>
    <style type="text/css">
        html, body, #app, .layout {
            height: 100%;
        }

        .layout {
            border: 1px solid #d7dde4;
            background: #f5f7f9;
            position: relative;
            border-radius: 4px;
            overflow: hidden;
        }

        .layout-header-bar {
            background: #fff;
            box-shadow: 0 1px 1px rgba(0, 0, 0, .1);
        }

        .layout-logo-left {
            width: 90%;
            height: 30px;
            background: #5b6270;
            border-radius: 3px;
            margin: 15px auto;
        }

        .menu-icon {
            transition: all .3s;
        }

        .menu-inner-icon {
            transition: all .3s;
        }

        .rotate-icon {
            transform: rotate(-90deg);
        }

        .rotate-inner-icon {
            transform: rotate(-90deg);
        }

        .menu-item span {
            display: inline-block;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            vertical-align: bottom;
            transition: width .2s ease .2s;
        }

        .menu-item i {
            transform: translateX(0px);
            transition: font-size .2s ease, transform .2s ease;
            vertical-align: middle;
            font-size: 16px;
        }

        .menu-inner-item-show {
            display: block;
        }

        .menu-inner-item-dismiss {
            display: none;
        }
    </style>
</head>
<body>
<div id="app">
    <layout class="layout">
        <sider ref="sidemenu" hide-trigger collapsible :collapsed-width="0" v-model="isCollapsed"
        >
            <i-menu theme="dark" width="auto" :class="menuitemClasses">
                <menu-item style="padding: 10px 5px;text-align: center">
                    <row>
                        <i-con>
                            <icon type="ios-plus-outline"></icon>
                            <span @click="showProjectItem">添加工程</span>
                        </i-con>
                    </row>
                    <row id="el_row_project_item" span="24" style="margin-top: 8px;display: none;">
                        <i-input size="small" placeholder="录入工程名" type="text">
                            <span @click="addProjectItem" slot="append">确定</span>
                        </i-input>
                    </row>
                </menu-item>
                <v-menu-root
                        v-for="(item,index) in mProjectes"
                        v-bind:item="item"
                        v-bind:key="item.id"
                        v-bind:index="index">
                </v-menu-root>
            </i-menu>
        </sider>
        <layout>
            <i-header :style="{padding: 0}" class="layout-header-bar">
                <row type="flex" justify="left" align="middle">
                    <i-col span="4" style="padding: 0 20px">
                        <icon @click.native="onMenuBtnClick" :class="rotateIcon"
                              type="navicon-round" size="24"></icon>
                        <icon @click.native="collapsedInnerSider(0)" :class="rotateIconInner"
                              style="margin-left: 20px"
                              type="navicon-round" size="24"></icon>
                    </i-col>
                    <i-col span="10">
                        <breadcrumb>
                            <breadcrumb-item>{{mProjecteName}}</breadcrumb-item>
                            <breadcrumb-item>{{mFoderName}}</breadcrumb-item>
                            <breadcrumb-item>{{mInferfaceName}}</breadcrumb-item>
                        </breadcrumb>
                    </i-col>
                </row>
            </i-header>
            <i-content :style="{height: '100%'}" style="overflow-y:hidden;">
                <row type="flex" justify="center" align="middle" :style="{height: '100%'}">
                    <i-col span="3" :style="{height: '100%'}" :class="menuInnierItemClasses">
                        <sider ref="innersidemenu"
                               hide-trigger
                               collapsible
                               :collapsed-width="0"
                               style="width: 100%;min-width: 100%;max-width: 100%;"
                               v-model="isInnerCollapsed">
                            <i-menu theme="dark" width="auto" class="menu-item">
                                <menu-item style="padding: 5px 0px;text-align: center">
                                    <row>
                                        <icon type="ios-plus-outline"></icon>
                                        <span @click="showDocItem()">添加接口</span>
                                    </row>
                                    <row id="el_row_doc_item" span="24" style="margin-top: 8px;display: none;">
                                        <i-input size="small" placeholder="新接口名" type="text">
                                            <span @click="addDocItem()" slot="append">确定</span>
                                        </i-input>
                                    </row>
                                </menu-item>
                                <menu-item v-for="(interfaceItem,index) in mInterface">
                                    <span @click="onInterfacesItemClickListener(interfaceItem)" style="width: 100%">{{interfaceItem.inName}}</span>
                                </menu-item>
                            </i-menu>
                        </sider>
                    </i-col>
                    <i-col span="21" :style="{height: '100%'}">
                        <iframe id="contentFrame" src="${_basePath}splash" width="100%" height="100%" frameBorder=0
                        ></iframe>
                    </i-col>
                </row>
            </i-content>
        </layout>
    </layout>
    <Modal v-model="is_showDialog" :title='dialogTitle'>{{dialogContent}}</Modal>
</div>
<script type="vue/template" id="menuRootTemplate">
    <submenu :name="item.id">
        <template slot="title">
            {{item.prName}}
        </template>
        <menu-item>
            <row>
                <icon type="ios-plus-outline"></icon>
                <span @click="showFoderItem(item,index)">&nbsp文件夹</span>
            </row>
            <row :id="item.prName" span="24" style="margin-top: 8px;display: none;">
                <i-input size="small" placeholder="新文件夹名" type="text">
                    <span @click="addFoderItem(item,index)" slot="append">确定</span>
                </i-input>
            </row>
        </menu-item>
        <menu-item v-for="(foderItem,index) in item.foders">
            <Icon type="folder"></Icon>
            <span @click="onItemSelectdListener(foderItem.id,item.prName,foderItem.foName)">{{foderItem.foName}}</span>
        </menu-item>
    </submenu>
</script>
<script type="text/javascript">

    Vue.component('v-menu-root', {
        props: ['item', 'key', 'index'],
        template: '#menuRootTemplate',
        created: function () {
            var i = this.index;
            $.post(basePath + "foder/getFoders", {pr_id: this.item.id}, function (response) {
                if (response.status === 0) {
                    mApp.mProjectes[i].foders = response.data;
                } else {
                    mApp.showToast(response.msg, 0);
                }
            }, 'json');
        },
        methods: {
            onItemSelectdListener: function (fo_id, pr_name, fo_name) {
                mApp.mProjecteName = pr_name;
                mApp.mFoderName = fo_name;
                innerStorage.set('fo_id', fo_id);
                mApp.get_interfaces(fo_id);
                mApp.collapsedInnerSider(true);
                mApp.is_show = false;
            },
            showFoderItem: function (item, index) {
                $('#' + item.prName).slideToggle();
            },
            addFoderItem: function (item, index) {
                var name = $('#' + item.prName + ' input').val();
                if (isEmpty(name)) {
                    mApp.showToast('请填写文件夹名', 0);
                    return;
                }
                $.post(basePath + "foder/addFoder", {
                    fo_name: name,
                    pr_id: item.id
                }, function (response) {
                    if (response.status === 0) {
                        mApp.showToast('添加成功!');
                        mApp.mProjectes[index].foders.push(response.data);
                    } else {
                        mApp.showToast(response.msg, 0);
                    }
                }, 'json');
            }
        }
    });
    var mApp = new Vue({
        el: '#app',
        data: {
            mProjecteName: '',
            mFoderName: '',
            mInferfaceName: '',
            mProjectes: [],
            mInterface: [],
            dialogTitle: '温馨提示',
            dialogContent: '',
            is_show: false,
            is_showDialog: false,
            isCollapsed: false,
            isInnerCollapsed: false
        },
        components: {},
        computed: {
            rotateIcon: function () {
                return [
                    'menu-icon', this.isCollapsed ? 'rotate-icon' : ''
                ];
            },
            rotateIconInner: function () {
                return [
                    'menu-inner-icon', this.isInnerCollapsed ? '' : 'rotate-inner-icon'
                ];
            },
            menuitemClasses: function () {
                return ['menu-item']
            },
            menuInnierItemClasses: function () {
                return ['menu-item', this.isInnerCollapsed ? 'menu-inner-item-show' : 'menu-inner-item-dismiss']
            }
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
            collapsedSider: function () {
                if (!mApp.is_show) {
                    this.$refs.sidemenu.toggleCollapse();
                }
            },
            onMenuBtnClick: function () {
                mApp.is_show = false;
                mApp.collapsedSider();
            },
            collapsedInnerSider: function (type) {
                if (type === 0) {
                    this.$refs.innersidemenu.toggleCollapse();
                } else {
                    mApp.isInnerCollapsed = type;
                    mApp.is_show = type;
                }
            },
            onInterfacesItemClickListener: function (item) {
                mApp.mInferfaceName = item.inName;
                innerStorage.set('in_id', item.id);
                $('#contentFrame').attr('src', basePath + 'work');
                mApp.collapsedSider();
                mApp.collapsedInnerSider(true);
            },
            get_projectes: function () {
                $.post(basePath + "project/getProjects", {}, function (response) {
                    if (response.status === 0) {
                        if (response.data) {
                            mApp.mProjectes = response.data;
                        }
                    } else {
                        mApp.showToast(response.msg, 0);
                    }
                }, 'json');
            },
            get_interfaces: function (fo_id) {
                $.post(basePath + "interface/getInterfaces", {fo_id: fo_id},
                    function (response) {
                        if (response.status === 0) {
                            if (response.data) {
                                mApp.mInterface = response.data;
                            }
                        } else {
                            mApp.showToast(response.msg, 0);
                        }
                    }, 'json');
            },
            showProjectItem: function () {
                $('#el_row_project_item').slideToggle();
            },
            addProjectItem: function () {
                var name = $('#el_row_project_item input').val();
                console.info(name);
                if (isEmpty(name)) {
                    mApp.showToast('请填写工程名', 0);
                    return;
                }
                $.post(basePath + "project/addProject", {
                    pr_name: name
                }, function (response) {
                    if (response.status === 0) {
                        mApp.showToast('添加成功!');
                        mApp.mProjectes.push(response.data);
                        $('#el_row_project_item input').val('')
                    } else {
                        mApp.showToast(response.msg, 0);
                    }
                }, 'json');
            },
            showDocItem: function () {
                $('#el_row_doc_item').slideToggle();
            },
            addDocItem: function () {
                var name = $('#el_row_doc_item input').val();
                if (isEmpty(name)) {
                    mApp.showToast('请填写接口名', 0);
                    return;
                }
                $.post(basePath + "interface/saveInterface", {
                        fo_id: innerStorage.get('fo_id'),
                        in_id: '0',
                        in_name: name
                    },
                    function (response) {
                        if (response.status === 0) {
                            mApp.showToast('保存成功');
                            mApp.mInterface.push(response.data);
                        } else {
                            mApp.showToast(response.msg, 0);
                        }
                    }, 'json');
            }
        },
        created: function () {
            setTimeout(function () {
                mApp.get_projectes();
            }, 500);
        }
    });
</script>
</body>
</html>
