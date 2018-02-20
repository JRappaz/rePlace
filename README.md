# rePlace: /r/place project reloaded

### Data

The original interactions dataset can be found [here](https://www.reddit.com/r/redditdata/comments/6640ru/place_datasets_april_fools_2017/)  

Artwork are given a single id in the file `data/group_export.csv` with the following format:  

```
x,y,artwork_id  
```

x,y are in the original coordinate system (the same that can be downloaded from Reddit)  

the groups_id SHOULD be the same as the original atlas file that can be found [here](https://raw.githubusercontent.com/RolandR/place-atlas/master/web/_js/atlas.js)  
This could be used to link artworks to their respective subreddits
