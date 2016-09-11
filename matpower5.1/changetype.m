 function changetype(hObj,~)
          switch get(hObj,'value')
              case 1
                  s = {'Apple','Banana','Pear'};
              case 2
                  s = {'Cabbage','Leek','Eggplant','Spinach'};
              case 3
                  s = {'Wombat','Platypus','Kangaroo'};
          end
          set(hm2,'string',s,'callback',@dosomething)
      end