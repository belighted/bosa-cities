// = require quill.min
// = require decidim/admin/quill_iframe_plugin
// = require decidim/admin/quill-image-drop-plugin.min
// = require_self

((exports) => {
  const quillFormats = ["bold", "italic", "link", "underline", "header", "list", "image", "video", "iframe"];

  const createQuillEditor = (container) => {
    const toolbar = $(container).data("toolbar");
    const disabled = $(container).data("disabled");

    let quillToolbar = [
      ["bold", "italic", "underline"],
      [{ list: "ordered" }, { list: "bullet" }],
      ["link", "clean"]
    ];

    if (toolbar === "full") {
      quillToolbar = [
        [{ header: [1, 2, 3, 4, 5, 6, false] }],
        ...quillToolbar,
        ["image", "video", "iframe"]
      ];
    } else if (toolbar === "basic") {
      quillToolbar = [
        ...quillToolbar,
        ["image", "video", "iframe"]
      ];
    }

    const $input = $(container).siblings('input[type="hidden"]');
    const quill = new Quill(container, {
      modules: {
        toolbar: quillToolbar,
        imageDrop: true
      },
      formats: quillFormats,
      theme: "snow"
    });

    const tb = quill.getModule('toolbar');
    tb.addHandler('iframe', function (value) {
      if (value) {
        const IframeFormat = Quill.import('formats/iframe');
        const template = IframeFormat.MODAL_TEMPLATE;
        $(this.container).append(template);
        $(document).foundation();
        $("#iframe-attrs-modal").foundation("open");
        $("#iframe-add-button").on("click", (e) => {
          const modal = $("#iframe-attrs-modal");
          const href = $(modal).find("#src").val();
          const width = $(modal).find("#width").val();
          const height = $(modal).find("#height").val();
          const frameborder = $(modal).find("#frameborder").val();
          const style = $(modal).find("#style").val();
          this.quill.format('iframe', {
            src: href,
            width: width,
            height: height,
            frameborder: frameborder,
            style: style,
          });
        });
      } else {
        this.quill.format('link', false);
      }
    });

    if (disabled) {
      quill.disable();
    }

    quill.on("text-change", () => {
      const text = quill.getText();

      // Triggers CustomEvent with the cursor position
      // It is required in input_mentions.js
      let event = new CustomEvent("quill-position", {
        detail: quill.getSelection()
      });
      container.dispatchEvent(event);

      if (text === "\n") {
        $input.val("");
      } else {
        $input.val(quill.root.innerHTML);
      }
    });

    quill.root.innerHTML = $input.val() || "";
  };

  const quillEditor = () => {
    $(".editor-container").each((idx, container) => {
      createQuillEditor(container);
    });
  };

  exports.Decidim = exports.Decidim || {};
  exports.Decidim.quillEditor = quillEditor;
  exports.Decidim.createQuillEditor = createQuillEditor;
})(window);
