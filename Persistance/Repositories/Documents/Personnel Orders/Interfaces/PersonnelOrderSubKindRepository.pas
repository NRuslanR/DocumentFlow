unit PersonnelOrderSubKindRepository;

interface

uses

  PersonnelOrderSubKind,
  DomainObjectRepository,
  PersonnelOrderSubKindFinder,
  SysUtils;

type

  IPersonnelOrderSubKindRepository =
    interface (IDomainObjectRepository)
    ['{5B7AFC92-7E77-4D27-849A-012D6BA15AF1}']

      function FindPersonnelOrderSubKindById(const SubKindId: Variant): TPersonnelOrderSubKind;

    end;

implementation

end.
