unit PersonnelOrderSubKindFinder;

interface

uses

  PersonnelOrderSubKind,
  SysUtils;

type

  IPersonnelOrderSubKindFinder = interface
    ['{589A2A88-7943-4113-A2C9-D82361DF6FC7}']

    function FindPersonnelOrderSubKindById(const SubKindId: Variant): TPersonnelOrderSubKind;

  end;

implementation

end.
