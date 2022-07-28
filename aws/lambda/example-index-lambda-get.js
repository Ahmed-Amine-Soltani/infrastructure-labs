exports.handler = (event, context, callback) => {
        const type = event.type;
        if (type == 'all') {
            callback(null, 'All data is here! ');
        }
        else if (type == 'single') {
            callback(null, 'The single user data is here! ');
        }
        else {
            callback(null, "Hello from Lambda ");
            }
        };
