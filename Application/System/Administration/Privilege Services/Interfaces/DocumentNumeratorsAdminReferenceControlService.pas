unit DocumentNumeratorsAdminReferenceControlService;

interface

uses

  ApplicationService,
  Controls,
  SysUtils;

type

  IDocumentNumeratorsAdminReferenceControlService = interface (IApplicationService)

    function GetDocumentNumeratorsAdminReferenceControl(
      const ClientId: Variant
    ): TControl;

  end;
  
implementation

end.
