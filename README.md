# flutter_image_search
An image search app using Google's Custom Search Engine, caching and debouncing.

## Getting Started
This currently only works on desktop for Windows and Mac as the file handling is simple; could be updated to support mobile, too, with a little effort. Not quite sure how to think about making it work on the web...

For this sample to work, you need a file called cse-engine-id.txt and cse-key.txt in the root folder. You can
get those values by setting up a [Google Custom Search Engine project](https://stackoverflow.com/a/34062436). The contents of the cse-engine-id.txt file should be the cx parameter of an API query and the contents of the cse-key.txt file should be the key parameter.

With these files in place, you can run the app like this:

```shell
$ flutter run -d macos
$ flutter run -d windows
```

And expect results like this:

<img src='readme/demo.gif' />

## Implementation Details
The debouncing is implemented with a little helper class.

The caching is implemented with another little helper class and then shared between the CSE helper and the CachingNetworkImage so that both CSE search results (limited to 100 free/day) and the image downloads are cached.

Selection is implemented with a RawMaterialButton, since it handles the clicking and the outlining.

## Room for improvement
Right now, the URL is checked for known image extensions to avoid attempting to show anything that isn't a known image type, but really the file should be downloaded and the MIME type checked.

Also, the file handling could easily be fixed to support mobile; PRs gratefully accepted!

Further, there is no cache clearing policy -- it just grows forever! This could certainly be improved.

Finally, I didn't implementing paging, which the CSE API supports. Instead I just show the first 10 results, which I consider good enough for demo purposes.

## Enjoy!