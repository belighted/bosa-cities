
((exports) => {
  let DefaultVideo = Quill.import('formats/video');

  class IframeFormat extends DefaultVideo {
    static create(value) {
      const node = super.create(value);
      node.setAttribute('frameborder', value.frameborder || '0');
      node.setAttribute('width', value.width || '');
      node.setAttribute('height', value.height || '');
      node.setAttribute('style', value.style || '');
      node.setAttribute('src', this.sanitize(value.src) || '');
      return node;
    }
  }

  IframeFormat.blotName = 'iframe';
  IframeFormat.className = 'ql-iframe';
  IframeFormat.tagName = 'iframe';
  IframeFormat.MODAL_TEMPLATE = `
<div id="iframe-attrs-modal" class="small reveal" data-reveal data-close-on-esc="false" data-close-on-click="false" aria-hidden="true" role="dialog">
  <h1>Add iframe</h1>
  <div class="row">
    <div class="columns">
      <div>
        <div class="field"><label for="src">Url<input id="src" type="text" placeholder="should start with 'http://' or 'https://'"></label></div>
        <div class="field"><label for="width">Width<input id="width" type="text" value="100%" placeholder="100%"></label></div>
        <div class="field"><label for="height">Height<input id="height" type="text" value="100%" placeholder="500px"></label></div>
        <div class="field"><label for="frameborder">Border width<input id="frameborder" type="text" value="0" placeholder="0 or 1"></label></div>
        <div class="field"><label for="style">CSS style<input id="style" type="text"></label></div>
      </div>
      <div class="actions text-center">
        <button data-close class="close-button"><span aria-hidden="true">&times;</span></button>
        <button data-close id="iframe-add-button" class="button">Add iframe</button>
        <button data-close class="button secondary">Cancel</button>
      </div>
    </div>
  </div>
</div>
`;

  const icons = Quill.import('ui/icons');
  icons['iframe'] = `<svg class="svg-icon" viewBox="0 0 20 20"><path d="M17.701,3.919H2.299c-0.223,0-0.405,0.183-0.405,0.405v11.349c0,0.223,0.183,0.406,0.405,0.406h15.402c0.224,0,0.405-0.184,0.405-0.406V4.325C18.106,4.102,17.925,3.919,17.701,3.919 M17.296,15.268H2.704V7.162h14.592V15.268zM17.296,6.352H2.704V4.73h14.592V6.352z M5.947,5.541c0,0.223-0.183,0.405-0.405,0.405H3.515c-0.223,0-0.405-0.182-0.405-0.405c0-0.223,0.183-0.405,0.405-0.405h2.027C5.764,5.135,5.947,5.318,5.947,5.541"></path></svg>`;

  Quill.register(IframeFormat);

})(window);