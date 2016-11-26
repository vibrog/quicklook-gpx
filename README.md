# quicklook-gpx

This is a simple QuickLook plugin to browse [GPX](http://www.topografix.com/gpx) files.

### Customization

The plugin uses [OpenLayers](http://openlayers.org/) to render a map
preview using map tiles for Norway provided by The Norwegian Mapping
Authority, [Kartverket](http://kartverket.no/). To use different
background map tiles, edit `template.html` and change `ol.source.XYZ`.

### Installation Instructions

- Build the project in XCode by going to **Product** > **Build**. 
- Then expand **Products** in the Project navigator, right click `quicklook-gpx.qlgenerator` and choose **Show in Finder**.
- Copy `quicklook-gpx.qlgenerator` to `~/Library/QuickLook/`.
  (You may need to create the QuickLook folder if it doesn't exist.)
- Finder may pick it up automatically, but if it doesn't, you can run `qlmanage -r` to reload the plugins.
