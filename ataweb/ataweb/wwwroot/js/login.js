
Ext.application({
    name: 'Blog',

    //models: ['Post', 'Comment'],

    //controllers: ['Posts', 'Comments'],

    launch: function () {
        Ext.create('Ext.window.Window', {
            autoShow: true,
            height: 180,
            width: 400,
            layout: {
                type: 'fit'
            },
            iconCls: 'fa fa-key fa-lg',
            title: 'Welcome',
            closeAction: 'hide',
            closable: false,
            draggable: false,
            resizable: false,
            items: [
                {
                    xtype: 'form',
                    bodyPadding: 15,
                    defaults: {
                        xtype: 'textfield',
                        allowBlank: false,
                        selectOnFocus: true,
                        anchor: '100%',
                        labelWidth: 70,
                        listeners: {
                            specialKey: 'onTextFieldSpecialKey'
                        }
                    },
                    items: [{
                        name: 'username',
                        fieldLabel: 'user'
                    }, {
                        name: 'password',
                        id: 'txtPassword',
                        inputType: 'password',
                        vtype: 'customPass',
                        fieldLabel: 'password',
                        enableKeyEvents: true,
                        listeners: {
                            keypress: 'onTextFieldKeyPress',
                            specialKey: 'onTextFieldSpecialKey'
                        }
                    }],
                    dockedItems: [{
                        xtype: 'toolbar',
                        dock: 'bottom',
                        items: [{
                            xtype: 'tbfill'
                        }, {
                            xtype: 'button',
                            width: 100,
                            iconCls: 'fa fa-home fa-lg',
                            text: 'Home',
                        }, {
                            xtype: 'button',
                            itemId: 'btnLogin',
                            formBind: true,
                            width: 100,
                            ico: 'fa fa-sign-in fa-lg',
                            //plugins: ['spin'],
                            text: 'Login',
                        }]
                    }]
                }
            ]
        })
    }
});