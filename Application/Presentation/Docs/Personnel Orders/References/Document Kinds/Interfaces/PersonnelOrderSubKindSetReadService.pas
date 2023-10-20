unit PersonnelOrderSubKindSetReadService;

interface

uses

  PersonnelOrderSubKindSetHolder,
  ApplicationService,
  VariantListUnit,
  SysUtils;

type

  IPersonnelOrderSubKindSetReadService = interface (IApplicationService)

    function GetPersonnelOrderSubKindSet: TPersonnelOrderSubKindSetHolder;
    function GetPersonnelOrderSubKindSetByIds(const SubKindIds: array of Variant): TPersonnelOrderSubKindSetHolder;

  end;

implementation

end.
