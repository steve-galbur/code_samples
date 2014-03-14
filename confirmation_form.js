{
    initComponent:
        function(){
            this.callParent();
        },

    onConfirmation: function() {
        // Create and show the mask
        if (!this.maskCmp) this.maskCmp = new Ext.LoadMask(this.getEl(), {msg: "Sending..."});
        this.maskCmp.show();
        var values = this.getForm().getValues();
        var me = this;
        Ext.Ajax.request({
            url: '/api/v1/users/confirmation',
            method: "POST",
            params: values,

            success: function(response){
                me.maskCmp.hide();
                me.up('.window').close();
                me.confirmationSuccess();
            },

            failure: function(response, options) {
                me.maskCmp.hide();
                var popup_errors = response.responseText;
                try {
                    var json = Ext.JSON.decode(response.responseText);
                    me.getForm().markInvalid({"user[email]" : json.email[0]});
                    popup_errors = Ext.JSON.encode({'errors': "Email " + json.email[0]});
                } catch(error){}
                me.confirmationFailure(popup_errors);
            }
        });
    },

    onSignIn: function() {
        this.up().netzkeLoadComponent({name: "sign_in_form", callback: function(w) {
            w.show();
        }});
    },

    onForgot: function() {
        this.up().netzkeLoadComponent({name: "forgot_form", callback: function(w) {
            w.show();
        }});
    },

    onUnlock: function() {
        this.up().netzkeLoadComponent({name: "unlock_form", callback: function(w) {
            w.show();
        }});
    }
}
