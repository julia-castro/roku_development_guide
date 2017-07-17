Sub init()
  m.RowList = m.top.findNode('RowList')
  m.Title = m.top.findNode('Title')
  m.Description = m.top.findNode('Description')
  m.Poster = m.top.findNode('Poster')

  m.RowList.setFocus(true)
  m.LoadTask = CreateObject('roSGNode', 'FeedParser')
  m.LoadTask.control = 'RUN'
  m.LoadTask.observeField('content', 'rowListContentChanged')
End Sub

Sub rowListContentChanged()
  m.RowList.content = m.LoadTask.content
  m.RowList.observeField('rowItemFocused', 'changeContent')
end Sub

Sub changeContent()
  contentItem = m.RowList.content.getChild(m.RowList.rowItemFocused[0]).getChild(m.RowList.rowItemFocused[1])

  m.top.backgroundUri = contentItem.HDPOSTERURL
  m.Poster.uri = contentItem.HDPOSTERURL
  m.Title.text = contentItem.TITLE
  m.Description.text = contentItem.Description
end Sub
