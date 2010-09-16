commands.addUserCommand(['dmark'], "Bookmark page on Delicious",
    function(args) {
        var url = [
            'https://api.del.icio.us/v1/posts/add?',
            '&url=', encodeURIComponent(buffer.URL),
            '&description=', encodeURIComponent(buffer.title),
            '&shared=no',
            '&tags=', encodeURIComponent(args.string)
        ];
        url = url.join('');
        var xhr = new XMLHttpRequest();
        xhr.open('POST', url, false);
        xhr.send(null);
        liberator.echo(xhr.responseTextj);
    }
);
