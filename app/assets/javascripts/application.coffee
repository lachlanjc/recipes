#= require jquery3
#= require jquery_ujs
#= require turbolinks
#= require lodash
#= require modals
#= require clipboard
#= require global

$(document).on 'turbolinks:load', ->
  N.user = $('body').data('user')
  N.signed_in = _.isNumber N.user
  N.anonymous = !N.signed_in
  N.my_object = (N.signed_in && _.isEqual(N.user, N.object_user)) || false

  N.toggleMenu = (m) ->
    $(m).find('[data-behavior~=menu_content]').slideToggle 100
    o = $(m).attr('aria-expanded') is 'true'
    $(m).attr 'aria-expanded', !o

  # Popover menus
  $(document).on 'click', (e) ->
    o = $(N.openMenuSelector)
    c = $(e.target).closest('[data-behavior~=menu_toggle]')
    if o.length > 0 or c.length > 0
      N.toggleMenu `o.length > 0 ? o : c`
    e.stopImmediatePropagation()
    return
  $(document).keydown (e) ->
    # Close popover menus on esc
    if e.keyCode is 27 and $(N.openMenuSelector).length > 0
      N.toggleMenu $(N.openMenuSelector)

  N.s('flash').delay(5 * 1e3).fadeOut('fast')

  totalModalize()

  $(document).on 'keydown', 'action, [data-behavior~=r_fav]', (e) ->
    $(this).click() if e.keyCode is 32 or e.keyCode is 13

  $('[data-behavior~=inline_signup_form]').on 'ajax:beforeSend', ->
    t = $(this)
    t.html null
    t.toggleClass 'busy busy--large mx-auto'
    t.find('[data-behavior~=hide_on_inline_submit]').hide()
  $(document).on 'ajax:success', '[data-behavior~=inline_signup_form]', ->
    t = $(this)
    if b = $('[data-behavior~=inline_signup_btn]')
      b.blur()
      b.hide()
      b.parent().append '<p class="blue b">Signed up! Thanks 😊</p>'
    t.closest('.modal').find('[data-behavior~=modal_close]').click()
    u = window.location.pathname
    if !_.isEmpty u.match 'explore'
      r = -> location.reload()
    else
      r = -> window.location = '/recipes'
    setTimeout r, 600
  $(document).on 'ajax:error', '[data-behavior~=inline_signup_form]', ->
    $(this).toggleClass 'busy busy--large mx-auto bg-darken-1 border rounded pvm mt2 tc'
    $('[data-behavior~=inline_signup_error]').toggleClass 'dn'

  $('[data-behavior~=r_fav_trigger]').on 'change', ->
    $(this)[0].form.submit()
  $(document).on 'click', '[data-behavior~=print]', ->
    window.print()

  # Add preview to embed modal, but only on the first open
  $(document).one 'click', '[data-behavior~=embed_trigger]', ->
    $('#embed').append $('#embed [data-behavior~=copy]').data('clipboard-text')
    $('.section-header').show 0

  N.addGroceries = (el) ->
    t = _.trim $(el).text()
    p = "class='add-grocery sans tooltipped tooltipped--n' aria-label='Add to your grocery list'"
    unless N.exists $(el).find(N.s('add_grocery'))
      $(el)
        .append("<div data-behavior='add_grocery' #{p} data-value='#{t}'></div>")
        .find('[data-behavior~=add_grocery]')
  N.addGroceries li for li in N.s('recipe_ingredients').find('li') if N.signed_in
  $(document).on 'click', '[data-behavior~=add_grocery]', ->
    t = $(this)
    $.post '/groceries', { grocery: { name: t.data('value') } }, (e) ->
      t.addClass 'add-grocery--done'
      t.attr 'aria-label', 'Added!'
  $(document).on 'click', '[data-behavior~=grocery_suggestion]', (e) ->
    N.updateGroceryName $(this).text(), false

  pn = window.location.pathname
  if N.theres('recipe_colls_container') and _.includes(pn, '/recipes/')
    if _.isEqual N.s('recipe_colls_container').data('user'), N.user
      $.get _.replace(pn, '/edit', '') + '/collections', (e) ->
        N.s('recipe_colls_container').html e
        N.s('recipe_colls_inactive').hide 0
        if _.includes(pn, '/edit')
          N.s('recipe_colls_submit').remove() 
          N.s('recipe_add_colls').hide()
          N.s('recipe_colls_inactive').show()
          $(document).on 'change', '[data-behavior~=recipe_colls_check]', ->
            N.s('recipe_colls_form').submit()
        $(document).on 'click', '[data-behavior~=recipe_add_colls]', ->
          N.s('recipe_add_colls').fadeOut 'fast'
          N.s('recipe_colls_inactive').fadeIn 'fast'
        $(document).on 'change', '[data-behavior~=recipe_colls_check]', ->
          N.s('recipe_colls_submit').fadeIn 'fast'
        $(document).on 'ajax:error', '[data-behavior~=recipe_colls_form]', (one, two) ->
          N.s('recipe_colls_form').find('input[type=submit]').text '!!!!'
          console.error one, two
        $(document).on 'ajax:success', '[data-behavior~=recipe_colls_form]', ->
          N.s('recipe_colls_submit').fadeOut 'fast'

  clipboard = new Clipboard '[data-behavior~=copy]', text: (trigger) ->
    trigger.getAttribute 'data-clipboard-text'
  clipboardReset = (t) ->
    t.text 'Copied!'
    setTimeout (-> t.text 'Copy'), 1500
  clipboard.on 'success', (e) ->
    clipboardReset $(e.trigger)
    e.clearSelection()
    return

  # Switch .dn for inline style (prevents flash on load)
  N.s('rehide').hide().removeClass('dn')

  # Show when in various user states – conditionally fill in cached pages
  N.s('show_if_anonymous').removeClass 'dn' if N.anonymous
  N.s('show_if_signed_in').removeClass 'dn' if N.signed_in
  N.s('show_unless_mine').removeClass 'dn' unless N.signed_in
  N.s('show_if_my_object').removeClass 'dn' if N.my_object

  if N.theres 'autoselect'
    N.s('autoselect').focus().select()
    $(document).on 'click', '[data-behavior~=autoselect]', (e) ->
      t = e.target
      t.selectionStart = 0
      t.selectionEnd = 999

  $(document).on 'click', '[data-behavior~=photo_button]', ->
    $('[data-behavior~=photo_field]')[0].click()
  $('[data-behavior~=photo_field]').on 'change', ->
    d = N.s('photo_button').find('[data-behavior~=description]')
    d.text this.value.match(/[^\/\\]+$/)[0]
    N.s('recipe_errors').hide 256
    if f = document.querySelector('[data-behavior~=photo_field]').files[0]
      r = new FileReader
      r.addEventListener 'load', (->
        $('[data-behavior~=editor_photo]').animate { height: 64 }, 150, ->
          $('[data-behavior~=editor_photo_preview]').attr 'src', r.result
          $('[data-behavior~=editor_photo_cont]').show()
      ), false
      r.readAsDataURL f
  $(document).on 'click', '[data-behavior~=remove_current_photo]', ->
    t = $(this)
    d = t.find('[data-behavior~=description]')
    p = N.s 'editor_photo_preview'
    d.text 'Removing photo...'
    v = 'blur(1px) grayscale(1)'
    p.css { 'filter': v, '-webkit-filter': v }
    $('[data-behavior~=photo_field]').val null
    $.get $(this).data('href'), (e) ->
      d.text 'Removed!'
      N.s('editor_photo_cont').hide 256, -> p.attr 'style', ''
      t.hide 'slow'
    N.s('recipe_errors').hide 256

  if N.theres 'font_dec'
    $('html').css 'font-size', 16
  N.getFontSize = ->
    _.toNumber _.replace($('html').css('font-size'), 'px', '')
  N.changeFontSize = (a) ->
    $('html').css 'font-size', N.getFontSize() + a
  $(document).on 'click', '[data-behavior~=font_dec]', ->
    N.changeFontSize -2
  $(document).on 'click', '[data-behavior~=font_inc]', ->
    N.changeFontSize 2

  $('[data-behavior~=cook_photo_field]').on 'change', ->
    $(this)[0].form.submit()

  $(document).on 'click', '[data-behavior~=checklist_item]', ->
    $(this).toggleClass 'checked'

  $(document).on 'submit', '[data-behavior~=clip_form]', ->
    N.track 'clips-recipe', { 'URL': N.s('clip_url').val() }
  $(document).on 'click', '.stripe-button-el', ->
    N.track 'clicks-subscribe', {}
