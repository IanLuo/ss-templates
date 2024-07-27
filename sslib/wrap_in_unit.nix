{ defineUnit }:
{ drv }:

if (drv ? isUnit) && drv.isUnit
then
  drv
else
  defineUnit {
    name = drv.name;
    value = drv;
  }

