Ext.application({
    name: 'test',
    launch: function () {
        Ext.create('Ext.container.Container', {
            renderTo: Ext.getBody(),
            layout: 'vbox',
            padding:'0 0 0 40',
            items: [{
                xtype: 'label',
                html:'<h1>Home Page</h1>'
            }, {
                xtype: 'button',
                text: 'Sign Out',
                handler: function () {
                    Ext.Ajax.request({
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        url: '/Login/SignOut',
                        method: 'post',
                        success: function (res) {
                            var dataJson = JSON.parse(res.responseText);
                            if (dataJson.success) window.location.href = dataJson.data;
                        },
                    });
                }
            }]
        });
    }
});