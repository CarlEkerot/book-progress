Books = new Meteor.Collection "books"

Template.list.books = -> Books.find()

# Adding a new book
Template.add.events =
    'submit #new_book': (e) ->
        e.preventDefault()
        name = $('#new_book_name').val()
        pages = $('#pages').val()
        if name
            Books.insert(name: name, pages: pages, pages_read: 0)
            $('#new_book_name').val('')
            $('#pages').val('')
        $('#new_book_name').focus()

# Book-related events
Template.book.events =
    'keydown .pages_read': (e) ->
        if e.keyCode is 13 # Pressing enter
            val = $('#' + @_id + ' .pages_read').val()
            pages_read = Math.max(0, Math.min(@pages, parseInt(val)))
            Books.update(@_id, $set: {pages_read: pages_read})

    'click .increment': (e) ->
        incremented = parseInt($('#' + @_id + ' .pages_read').val()) + 1
        pages_read = Math.min(incremented, @pages)
        Books.update(@_id, $set: {pages_read: pages_read})

    'click .remove': (e) ->
        Books.remove(@_id)

Template.book.percent_done = ->
    val = Math.floor(100 * (@pages_read / @pages)) or 0
    return val