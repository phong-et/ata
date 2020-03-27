function generateQRcode(qrCode) {
    new QRCode(document.getElementById("qrcode"), {
        text: qrCode,
        width: 150,
        height: 150,
        colorDark: "#000000",
        colorLight: "#ffffff",
        correctLevel: QRCode.CorrectLevel.H
    });
}
var qrPopup = Ext.create('Ext.window.Window', {
    title: 'ReAuthenticate QR',
    height: 200,
    width: 400,
    layout: 'fit',
    draggable: false,
    resizable: false,
    border: 0,
    padding:'2 0 0 120',
    closeAction: 'method-hide',
    listeners: {
        'beforeshow': function () {
            Ext.Ajax.request({
                url: 'api/GenerateQR',
                success: function (res) {
                    generateQRcode(res.responseText);
                }
            });
        },
        'beforehide': function () {
            document.getElementById("qrcode").innerHTML = "";
        }
    },
    items: {
        xtype: 'component',
        html: '<div id="qrcode"></div>'
    }
});

Ext.application({
    name: 'Login',
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
                    },
                    items: [{
                        name: 'email',
                        id: 'txtEmail',
                        fieldLabel: 'Email'
                    }, {
                        name: 'password',
                        id: 'txtPassword',
                        inputType: 'password',
                        fieldLabel: 'Password',
                        enableKeyEvents: true,
                    }],
                    dockedItems: [{
                        xtype: 'toolbar',
                        dock: 'bottom',
                        layout: {
                            type: 'hbox',
                            pack: 'center'
                        },
                        items: [{
                            xtype: 'button',
                            width: 100,
                            iconCls: 'fa fa-qrcode',
                            text: 'QR Code',
                            handler: function () {
                                qrPopup.show();
                            }
                        }, {
                            xtype: 'button',
                            width: 80,
                            iconCls: 'fa fa-sign-in',
                            text: 'Sign In',
                            handler: function () {
                                Ext.Ajax.request({
                                    headers: {
                                        'Content-Type': 'application/x-www-form-urlencoded'
                                    },
                                    url: '/Login/SignIn',
                                    method: 'post',
                                    params: {
                                        jsonUser: JSON.stringify({
                                            email: Ext.getCmp('txtEmail').getValue(),
                                            password: Ext.getCmp('txtPassword').getValue(),
                                            returnSecureToken: true,
                                        })
                                    },
                                    success: function (res) {
                                        var dataJson = JSON.parse(res.responseText);
                                        if (dataJson.success) window.location.href = dataJson.data;
                                        else alert(dataJson.data);
                                    },
                                    failure: function (res) {
                                        console.log('server-side failure with status code ' + res.status);
                                    }
                                });
                            },
                        }]
                    }]
                }
            ]
        })
    }
});