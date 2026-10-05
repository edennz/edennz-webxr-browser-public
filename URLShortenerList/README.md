# URLShortenerList

A tiny Swift package that bundles the
[PeterDaveHello/url-shorteners](https://github.com/PeterDaveHello/url-shorteners) domain list
(`Sources/URLShortenerList/Resources/list.txt`, unmodified) and exposes it as `URLShortenerList.hosts`,
together with the attribution and license text the list's
[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license requires.

This directory is kept self-contained so it can be published on its own:

```bash
git subtree split --prefix=ThirdParty/URLShortenerList -b url-shortener-list
git push <public-remote> url-shortener-list:main
```

Refresh the list from upstream with:

```bash
curl -sL https://raw.githubusercontent.com/PeterDaveHello/url-shorteners/master/list \
  -o Sources/URLShortenerList/Resources/list.txt
```

Everything in this directory is licensed CC BY-SA 4.0 (see `LICENSE`).
