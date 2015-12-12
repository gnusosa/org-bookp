;;; org-bookp.el --- Functions to deal with book metadata and properties
;; Version: 0.0.1
;; Author: Carlos Sosa
;; URL: https://github.com/gnusosa/org-bookp

;; This file is NOT part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program ; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;;; org-bookp is intended to be used as a org-module, and with
;;; org-headings with TODO keywords and tags like BOOKS-BOOK-TEXTBOOK.
;;; Anything with the pattern {book,BOOK} will be pick up by
;;; org-bookp-last-page-maybe.

;;; org-bookp-last-page-maybe is intended to be used as a org-clock-out-hook function.
;;; Use: (add-hook 'org-clock-out-hook 'org-bookp-last-page-maybe 'append)
(require 'org)
(require 's)

(defvar org-bookp-basic-metadata '("ISBN"
                                 "Authors"
                                 "Title"
                                 "Publishers"
                                 "Publication Date"
                                 "Language")
  "Basic Book Metadata as a list.")

(defvar org-bookp-last-read-page-property-name "LAST_READ_PAGE"
  "Last read page property name.")

;;;###autoload
(defun org-bookp-set-metadata-drawer ()
  "Inserts a basic template of a book metadata into the PROPERTIES drawer of an org-heading.
  \nProperties with spaces will be turned into a snake-case property."
  (interactive)
  (dolist (property org-bookp-basic-metadata)
    (org-set-property (upcase (s-snake-case property)) property)))

;;;###autoload
(defun org-bookp-last-page-maybe ()
  "Checks for any BOOK heading or tag in an org-heading if any is found,\nit will call org-bookp-set-last-page.
  \nThis function is intended to be used as an org-clock-out-hook action. For example:

  (add-hook 'org-clock-out-hook 'org-bookp-last-page-maybe 'append)
  "
  (let ((keyword (nth 2 (org-heading-components)))
        (tag (nth 5 (org-heading-components))))
    (if (or (string-match-p "book" keyword)
           (string-match-p "book" tag))
        (org-bookp-set-last-page))))

;;;###autoload
(defun org-bookp-set-last-page (&optional page)
  "Set a last read page property into the PROPERTIES drawer of an org-heading."
  (interactive)
  (org-set-property org-bookp-last-read-page-property-name (if (not (equal nil page))
                                                               page
                                                             (read-string "Enter the last page read:"))))

(provide 'org-bookp)
;; Local Variables:
;; coding: utf-8-emacs
;; End:

;;; org-bookp.el ends here
