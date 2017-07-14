Sub Init()
  m.top.functionName = 'loadContent'
End Sub

Sub loadContent()
  list = GetContentFeed()
  m.top.content - ParseXMLContent(list)
End Sub

Function ParseXMLContent(list As Object)
  RowItems = createObject('RoSGNode', 'ContentNode')

  for each rowAA in list
    row = createObject('RoSGNode', 'ContentNode')
    row.Title = rowAA.Title

    for each itemAA in rowAA.ContentList
      item = createObject('RoSGNode', 'ContentNode')
      item.SetFields(itemAA)
      row.appendChild(item)
    end for
    RowItems.appendChild(row)
  end for
  return RowItems

End Function

Function GetContentFeed()
  url = CreateObject('roUrlTransfer')
  url.SetUrl('http://api.delvenetworks.com/rest/organizations/59021fabe3b645968e382ac726cd6c7b/channels/1cfd09ab38e54f48be8498e0249f5c83/media.rss')
  rsp = url.GetToString()

  responseXML = ParseXML(rsp)

  if responseXML <> invalid then
    responseXML = responseXML.GetChildElements()
    responseArray = responseXML.GetChildElements()
  End if

  result = []

  for each xmlItem in responseArray
    if xmlItem.getName() = 'item'
      itemAA = xmlItem.GetChildElements()
      if itemAA <> invalid
        item = {}
        for each xmlItem in itemAA
          item[xmlItem.getName()] = xmlItem.getText()
          if xmlItem.getName() = 'media:content'
            item.stream = {url: xmlItem.url}
            item.url = xmlItem.getAttributes().url
            item.streamFormat = 'mp4'

            mediaContent = xmlItem.GetChildElements()
            for each mediaContentItem in mediaContent
              if mediaContentItem.getName() = 'media:thumbnail'
                item.HDPosterUrl = mediaContentItem.getattributes().url
                item.hdBackgroundImageUrl = mediaContentItem.getattributes().url
              end if
            end for
          end if
        end for
        result.push(item)
      end if
    end if
  end for
  return result
End Function

Function ParseXML(str As String) As dynamic
  if str = invalid return invalid
  xml = CreateObject('roXMLElement')
  if not xml.Parse(str) return invalid
  return xml
End Function
