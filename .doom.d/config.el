;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
(setq doom-theme 'doom-wilmersdorf)
(require 'prettier-js )
(setq prettier-js-args '(
                         "--trailing-comma" "all"
                         "--single-quote" "true"
                         ))
(map! :after rjsx-mode
      :map rjsx-mode-map
      "<" nil
      ">" nil)
