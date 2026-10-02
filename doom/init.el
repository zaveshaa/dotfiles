;;; init.el -*- lexical-binding: t; -*-

(doom! :completion
       vertico

       :ui
       doom
       modeline

       :editor
       (evil +everywhere)

       :emacs
       dired
       undo

       :lang
       org

       :config
       (default +bindings))
