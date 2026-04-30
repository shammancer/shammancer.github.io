Please create plan 06 in the plans folder for updating the index.

The new index is based on the index in the Deuterium.ca.html file.

Now that we created the cards it is time to create the new index page.

First create a index.json file that contains an array. Each item in the array should be an item in the navigation bar.

{
    "icon": <character>
    "title": <title>
    "link": <link>
    "description": <description>
    "colour": <colour>
}

The icon should be the utf8 character in the Deuterium.ca.html file.
The title should be the current link text.
The link should be the current href value.
The description should be pulled from the Deuterium.ca.html file.
The colour should be pulled from the Deuterium.ca.html file.

The blog object should be:
{
    "icon": "◈"
    "title": "Blog"
    "link": "/blog.html"
    "desciption": "Thoughts, posts, and dispatches from the grid.",
    "colour": "pink"
}

Second update the navigation portion of the header partial to be based on this index.json file.

Third update the index to a new erb template. It shoudl be based on the grid layout. It should consume the index.json file.