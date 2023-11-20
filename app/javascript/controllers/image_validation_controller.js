import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="image-validation"
export default class extends Controller {
  static targets = ["imageInput", "fileList", "fileCount"]

  connect() {
    this.updateFileList();
  }

  updateFileList() {
    this.fileListTarget.innerText = "";

    if (this.imageInputTarget.files.length > 0) {
      this.fileCountTarget.textContent = `${this.imageInputTarget.files.length} files selected`;
    } else {
      this.fileCountTarget.textContent = 'No files selected';
    }

    for (let i = 0; i < this.imageInputTarget.files.length; i++) {
      const file = this.imageInputTarget.files[i];
      const listItem = document.createElement('div');
      listItem.classList.add("flex", "items-center", "justify-between", "bg-gray-100", "rounded-md", "px-3", "py-2", "text-sm", "font-semibold", "text-gray-900", "shadow-sm", "hover:bg-gray-200", "focus-visible:outline", "focus-visible:outline-2", "focus-visible:outline-offset-2", "focus-visible:outline-indigo-600");
      listItem.textContent = file.name;

      const deleteButton = document.createElement('button');
      deleteButton.classList.add("text-red-500", "focus-visible:outline", "focus-visible:outline-2", "focus-visible:outline-offset-2", "focus-visible:outline-indigo-600");
      deleteButton.textContent = 'Delete';
      deleteButton.dataset.action = "click->image-validation#removeFile";
      deleteButton.dataset.index = i;

      listItem.appendChild(deleteButton);
      this.fileListTarget.appendChild(listItem);
    }
  }

  removeFile(event) {
    const index = parseInt(event.currentTarget.dataset.index);
    const filesArray = Array.from(this.imageInputTarget.files);
    filesArray.splice(index, 1);

    const newFileList = new DataTransfer();
    filesArray.forEach(file => {
      newFileList.items.add(file);
    });

    this.imageInputTarget.files = newFileList.files;

    // Clear and reset the input element's value
    if (this.imageInputTarget.files.length === 0) {
      this.imageInputTarget.value = "";
    }

    this.updateFileList();
  }
}
