$(() => {
  $('a.clear-attachment').click((e) => {
    e.preventDefault();
    $(e.currentTarget).siblings("input[type=file]").val('')
  });
});
