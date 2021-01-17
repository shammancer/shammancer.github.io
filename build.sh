podman build -t shammancer-github-io .
podman create --name shammancer-git-io --replace -p 8080:80 localhost/shammancer-github-io
rm -r build/
podman cp shammancer-git-io:/usr/local/apache2/htdocs/ build
podman rm shammancer-git-io
