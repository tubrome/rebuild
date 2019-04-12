/* eslint-disable no-undef */
let default_item
$(document).ready(function () {
  const query = 'entity=' + $urlp('entity') + '&field=' + $urlp('field')

  $.get(rb.baseUrl + '/admin/field/picklist-gets?isAll=true&' + query, function (res) {
    $(res.data).each(function () {
      if (this.hide === true) render_unset([this.id, this.text])
      else {
        let item = render_item([this.id, this.text])
        if (this['default'] === true) {
          default_item = this.id
          item.addClass('active')
        }
      }
    })
  })

  $('.J_confirm').click(function () {
    let text = $val('.J_text')
    if (!text) {
      rb.highbar('请输入选项文本')
      return false
    }
    let id = $('.J_text').attr('attr-id')
    $('.J_text').val('').attr('attr-id', '')
    $('.J_confirm').text('添加')
    if (!id) render_item([$random(), text])
    else {
      let item = $('.J_config li[data-key="' + id + '"]')
      item.attr('data-key', id)
      item.find('.dd3-content').text(text)
    }
    return false
  })

  $('.J_save').click(function () {
    let show_items = []
    $('.J_config>li').each(function () {
      let $this = $(this)
      let id = $this.attr('data-key')
      show_items.push({
        id: id,
        'default': id === default_item,
        text: $this.find('.dd3-content').text()
      })
    })
    let hide_items = []
    let force_del = 0
    $('.unset-list>li').each(function () {
      let $this = $(this)
      if ($this.data('del') === 'force') {
        force_del++
      } else {
        hide_items.push({
          id: $this.attr('data-key'),
          text: $this.find('.dd-handle').text().replace('[移除]', '')
        })
      }
    })
    let _data = {
      show: show_items,
      hide: hide_items
    }

    let $btn = $(this)
    let del_confirm = function () {
      $btn.button('loading')
      $.post(rb.baseUrl + '/admin/field/picklist-sets?' + query, JSON.stringify(_data), (res) => {
        if (res.error_code > 0) rb.hberror(res.error_msg)
        else parent.location.reload()
      })
    }

    if (force_del > 0) {
      rb.alert('将删除部分选项，已使用这些选项的数据（字段）将无法显示。<br>确定要删除吗？', {
        html: true,
        confirm: del_confirm
      })
    } else {
      del_confirm()
    }
  })
})
render_unset_after = function (item) {
  let del = $('<a href="javascript:;" class="action">[移除]</a>').appendTo(item.find('.dd-handle'))
  del.click(() => {
    del.text('[将在保存后彻底移除]')
    del.parent().parent().attr('data-del', 'force')
    return false
  })
}
render_item_after = function (item, data) {
  item.find('a').eq(0).text('[禁用]')
  let edit = $('<a href="javascript:;">[修改]</a>').appendTo(item.find('.dd3-action'))
  edit.click(function () {
    $('.J_text').val(data[1]).attr('attr-id', data[0])
    $('.J_confirm').text('修改')
  })

  let default0 = $('<a href="javascript:;">[默认]</a>').appendTo(item.find('.dd3-action'))
  default0.click(function () {
    $('.J_config li').removeClass('active')
    default0.parent().parent().addClass('active')
    default_item = data[0]
  })

  // 新增加的还未保存
  if (data[0].substr(0, 4) !== '012-') {
    item.find('.dd3-action>a:eq(0)').off('click').click(() => {
      item.remove()
    })
  }
}