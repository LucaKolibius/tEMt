function params = loadLang(params, lang)

if strcmp(lang, 'english')
    params.instructions1.a = 'Please imagine a story containing the two following images.';
    params.instructions1.b = 'After you have memorized each story, you will be asked';
    params.instructions1.c = 'to rate how plausible it is.';
    params.instructions1.d = 'Press arrow-key to start.';
    
    params.encoding.a = 'Plausible';
    params.encoding.b = 'Implausible';
    
    params.instructions2.a = 'During the next task you will see different numbers.';
    params.instructions2.b = 'If the number is odd, press left arrow.';
    params.instructions2.c = 'If the number is even, press right arrow.';
    params.instructions2.d = 'Press arrow-key to start.';
    
    params.distr.odd = 'Odd';
    params.distr.even = 'Even';
    
    params.instructions3.a = 'During the next task you will see one image.';
    params.instructions3.b = 'Please try to remember your story';
    params.instructions3.c = 'and recall the missing image (choose with "-").';
    params.instructions3.d = 'Press arrow-key to start.';
    
    params.retrieval.a = 'Do you remember the image that belongs here?';
    params.retrieval.b = 'No (left) / Yes (right)';
    
    params.break.a = 'Block completed. Take a short break ...';
    params.break.b = 'Press arrow-key to continue.';
    params.complete = 'Task completed. Thank you!';
    
    % tuning
    params.tunInstr1 = 'Please take a moment to read the instructions displayed below.';
    params.tunInstr2 = 'In the following task you will see different images.';
    params.tunInstr3 = 'Please indicate the category of each image.';
    params.tunInstr4 = 'If the image belongs to the FACE category, then press the LEFT arrow-key.';
    params.tunInstr5 = 'If the image belongs to the ANIMAL category, then press the DOWN arrow-key.';
    params.tunInstr6 = 'If the image belongs to the PLACE category, then press the RIGHT arrow-key.';
    params.tunInstr7 = 'Please maintain your gaze on the centre of the screen.';
    params.tunInstr8 = 'Press arrow-key to begin with the task.';
    params.tunInstrBreak1 = '% of task completed. Take a short break ...';
    params.tunInstrBreak2 = 'Press arrow-key to continue.';

elseif strcmp(lang,'german')
    params.instructions1.a = 'Bitte stellen Sie sich eine Geschichte mit den folgenden beiden Bildern vor.';
    params.instructions1.b = 'Im Anschluss werden Sie gefragt wie plausibel ';
    params.instructions1.c = 'diese Geschichte ist.';
    params.instructions1.d = 'Druecken Sie eine beliebige Pfeiltaste um zu beginnen.';
    
    params.encoding.a = 'Plausibel';
    params.encoding.b = 'Unplausibel';
    
    params.instructions2.a = 'Waehrend der naechsten Aufgabe werden Sie verschiedene Nummern sehen';
    params.instructions2.b = 'Ist die Nummer ungerade, druecken Sie die linke Pfeiltaste.';
    params.instructions2.c = 'Ist die Nummer gerade, druecken Sie die rechte Pfeiltaste.';
    params.instructions2.d = 'Druecken Sie eine beliebige Pfeiltaste um zu beginnen.';
    
    params.distr.odd = 'Ungerade';
    params.distr.even = 'Gerade';
    
    params.instructions3.a = 'Waehrend der naechsten Aufgabe sehen Sie ein Bild.';
    params.instructions3.b = 'Bitte versuchen Sie sich an Ihre Geschichte';
    params.instructions3.c = 'und das fehlende Bild zu erinnern (Auswahl mit "-").';
    params.instructions3.d = 'Druecken Sie eine beliebige Pfeiltaste um zu beginnen.';
    
    params.retrieval.a = 'Erinnern Sie sich an das dazugehoerige Bild?';
    params.retrieval.b = 'Nein (links) / Ja (rechts)';
    
    params.break.a = 'Block beendet. Nehmen Sie eine kurze Auszeit ...';
    params.break.b = 'Druecken Sie eine beliebige Pfeiltaste um fortzufahren.';
    params.complete = 'Aufgabe abgeschlossen. Vielen Dank!';
    
    % tuning
    params.tunInstr1 = 'Bitte nehmen Sie sich einen Augenblick Zeit um sich die Instruktionen durchzulesen';
    params.tunInstr2 = 'In der folgenden Aufgabe werden Sie verschiedene Bilder sehen';
    params.tunInstr3 = 'Bitte geben Sie die Kategorie dieser Bilder an';
    params.tunInstr4 = 'Wenn Sie ein GESICHT sehen, druecken Sie auf die LINKE Pfeiltaste.';
    params.tunInstr5 = 'Wenn Sie ein TIER sehen, druecken Sie auf die UNTERE Pfeiltaste.';
    params.tunInstr6 = 'Wenn Sie einen PLATZ sehen, druecken Sie auf die RECHTE Pfeiltaste.';
    params.tunInstr7 = 'Bitte sehen Sie stets auf die Mitte des Bildschirms.';
    params.tunInstr8 = 'Druecken Sie eine beliebige Pfeiltaste um zu beginnen.';
    params.tunInstrBreak1 = '% des Experiments beendet. Zeit fuer eine kurze Pause ...';
    params.tunInstrBreak2 = 'Druecken Sie eine beliebige Pfeiltaste um fortzufahren.';

elseif strcmp(lang, 'dutch')
    params.instructions1.a = 'Stel je een verhaal met de volgende twee plaatjes voor';
    params.instructions1.b = 'en probeer het verhaaltje te onthouden. Geef aan waneer je';
    params.instructions1.c = 'hiermee klaar bent of jou verhaal geloofwaardig of ongeloofwaardig is. ';
    params.instructions1.d = 'Druk een pijl knop om te beginnen.';
    
    params.encoding.a = 'Geloofwaardig';
    params.encoding.b = 'Ongeloofwaardig';
    
    params.instructions2.a = 'In het volgende deel van het experiment zie je telkens een getal';
    params.instructions2.b = 'Als het getal op het scherm oneven is, druk de linker pijl knop.';
    params.instructions2.c = 'Als het getal op het scherm even is, druk de rechter pijl knop.';
    params.instructions2.d = 'Druk een pijl knop om door te gaan.';
    
    params.distr.odd = 'Oneven';
    params.distr.even = 'Even';
    
    params.instructions3.a = 'In het volgende deel van het experiment zie je telkens een plaatje uit het eerste deel';
    params.instructions3.b = 'Probeer je te herinneren aan het bijbehorende verhaaltje';
    params.instructions3.c = 'en probeer je te herinneren aan het ontbrekende plaatje dat erbij hoort (druk op "-").';
    params.instructions3.d = 'Druk een pijl knop om door te gaan.';
    
    params.retrieval.a = 'Herinner je je aan het plaatje dat hierbij hoort?';
    params.retrieval.b = 'Nee (links) / Ja (rechts)';
    
    params.break.a = 'Yay, je bent klaar met dit blok. Neem een korte pauze ...';
    params.break.b = 'Druk een pijl knop om door te gaan.';
    params.complete = 'Je bent klaar met het experiment! Heel erg bedankt voor het meedoen!';
end