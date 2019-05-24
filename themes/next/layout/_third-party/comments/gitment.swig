{% if theme.gitment.enable and theme.gitment.client_id and theme.gitment.client_secret %}
    <div id="container_gitment"></div>
    <link rel="stylesheet" href="https://www.wenjunjiang.win/css/gitment.css">
    <script src="https://www.wenjunjiang.win/js/gitment.js"></script>
    <script>
      var gitment = new Gitment({
        id: '{{ page.title }}',
        owner: '{{ theme.gitment.github_id }}',
        repo: '{{ theme.gitment.repo }}',
        oauth: {
          client_id: '{{ theme.gitment.client_id }}',
          client_secret: '{{ theme.gitment.client_secret }}',
        }
      });
      gitment.render('container_gitment');
    </script>
{% endif %}
