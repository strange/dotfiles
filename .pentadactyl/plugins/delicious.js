group.commands.add(['dmark'], "Bookmark page on Delicious",
    function(args) {
        var url = [
            'https://api.del.icio.us/v1/posts/add?',
            '&url=', encodeURIComponent(buffer.URL),
            '&description=', encodeURIComponent(buffer.title),
            '&shared=no',
            '&replace=yes',
            '&tags=', encodeURIComponent(args.join(','))
        ];
        dactyl.echo("1");
        url = url.join('');
        dactyl.echo("2");

try {
    util.httpGet(url, {
        method: "POST",
        onload: function (req) {
            var status = req.responseXML.getElementsByTagName('result')[0].getAttribute('code');

            if(status == "done") {
                dactyl.echomsg("Worked");
            } else {
                dactyl.echomsg(status);
            }
        }
    });
} catch (e) {
    dactyl.echomsg(e);
}

dactyl.echo("3");



        // var xhr = new XMLHttpRequest();
        // dactyl.echo("3");
        // xhr.open('POST', url, false);
        // dactyl.echo("4");
        // xhr.send(null);
        // dactyl.echo("Before post");
        // if (xhr.status != 200) {
        //     dactyl.echo("Dude status");
        //     // dactyl.error("Error creating bookmark");
        // } else {
        //     dactyl.echo("Bookmark added");
        // }
    }
);
