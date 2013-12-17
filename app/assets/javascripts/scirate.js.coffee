class window.SciRate
  @login: -> redirect("/login")

class View extends Backbone.View

class View.Search extends View
  initialize: ->
    @updateFolder()

  events:
    'change #folder': "updateFolder"

  updateFolder: ->
    @$('.feed').addClass('hidden').attr('disabled', true)
    $sel = @$('#feed_' + @$('#folder').val())
    $sel.removeClass('hidden').attr('disabled', false)

class View.PaperItem extends View
  events:
    'click .scite': "scite"
    'click .unscite': "unscite"
    'click .expand': "expand"
    'click .collapse': "collapse"

  scite: ->
    $toggle = @$('.scite-toggle')
    paper_id = $toggle.attr('data-paper-id')
    $.post "/api/scite/#{paper_id}", (resp) =>
      @expand()
      $toggle.replaceWith(resp)
    return false

  unscite: ->
    $toggle = @$('.scite-toggle')
    paper_id = $toggle.attr('data-paper-id')
    $.post "/api/unscite/#{paper_id}", (resp) =>
      @collapse()
      $toggle.replaceWith(resp)
    return false

  expand: ->
    @$('.abstract').removeClass('hidden')
    @$('.expand').addClass('hidden')
    @$('.collapse').removeClass('hidden')

  collapse: ->
    @$('.abstract').addClass('hidden')
    @$('.expand').removeClass('hidden')
    @$('.collapse').addClass('hidden')


class View.SubscribeToggle extends View
  initialize: ->
    @fid = @$el.attr('data-feedid')

  events:
    'click .subscribe': "subscribe"
    'click .unsubscribe': "unsubscribe"
    'mouseenter .unsubscribe': "rolloverStart"
    'mouseleave .unsubscribe': "rolloverStop"

  subscribe: ->
    $.post "/api/subscribe/#{@fid}", (newel) =>
      @$el.html($(newel).html())

  unsubscribe: ->
    $.post "/api/unsubscribe/#{@fid}", (newel) =>
      @$el.html($(newel).html())

  rolloverStart: ->
    @$('.unsubscribe')
      .removeClass('btn-success')
      .addClass('btn-danger')
      .text("Unsubscribe")

  rolloverStop: ->
    @$('.unsubscribe')
      .removeClass('btn-danger')
      .addClass('btn-success')
      .text("Subscribed")

class View.AbstractToggle extends View
  initialize: ->
    if SciRate.current_user
      @expand = SciRate.current_user.expand_abstracts
    else
      @expand = false
    @render()

  events:
    'click': 'toggle'

  render: ->
    if @expand
      $('.abstract.hideable').removeClass('hidden')
      @$el.html('hide unscited abstracts')
    else
      $('.abstract.hideable').addClass('hidden')
      @$el.html('show all abstracts')

  toggle: ->
    if @expand
      @disable()
    else
      @enable()

  disable: ->
    @expand = false; @render()
    if SciRate.current_user
      $.post '/api/settings', { expand_abstracts: false }

  enable: ->
    @expand = true; @render()
    if SciRate.current_user
      $.post '/api/settings', { expand_abstracts: true }

$ ->
  $(document).ajaxError (ev, jqxhr, settings, err) ->
    if err == "Unauthorized"
      SciRate.login()

  # Setup generic dropdowns
  $('.dropdown').each ->
    $(this).mouseenter -> $(this).find('.dropdown-toggle').dropdown('toggle')
    $(this).mouseleave -> $(this).find('.dropdown-toggle').dropdown('toggle')

  # Make little paper widgets functional
  $('li.paper').each ->
    new View.PaperItem(el: this)

  # Feed subscription toggles
  $('.subscribe-toggle').each ->
    new View.SubscribeToggle(el: this)

  # Global toggle for showing all abstracts
  $('.abstract-toggle').each ->
    new View.AbstractToggle(el: this)

  # Welcome banner resend confirm button
  $('#resend-confirm-email').click ->
    $.post '/api/resend_confirm', ->
      $('#resend-confirm-email').popover(
        content: "Sent"
      )
    
  # Landing page specific
  $('#landing').each ->
    $('.searchbox input').focus()

  # Search page specific
  $('#search_page').each ->
    new View.Search(el: this)
