unit BasedOnVclZeosDocumentNumeratorsAdminReferenceControlService;

interface

uses

  DocumentNumeratorsAdminReferenceControlService,
  AbstractApplicationService,
  ZConnection,
  Controls,
  SysUtils;

type

  TBasedOnVclZeosDocumentNumeratorsAdminReferenceControlService =
    class (TAbstractApplicationService, IDocumentNumeratorsAdminReferenceControlService)

      private

        FZConnection: TZConnection;
        
      public

        constructor Create(ZConnection: TZConnection);
        
        function GetDocumentNumeratorsAdminReferenceControl(
          const ClientId: Variant
        ): TControl;

    end;

implementation

uses

  UnDocNumerators;

{ TBasedOnVclZeosDocumentNumeratorsAdminReferenceControlService }

constructor TBasedOnVclZeosDocumentNumeratorsAdminReferenceControlService.Create(
  ZConnection: TZConnection);
begin

  inherited Create;

  FZConnection := ZConnection;
  
end;

function TBasedOnVclZeosDocumentNumeratorsAdminReferenceControlService.
  GetDocumentNumeratorsAdminReferenceControl(const ClientId: Variant): TControl;
begin

  Result := InitDocNumerators(FZConnection);

  with TfrmDocNumerators(Result) do ExitToolVisible := False;
  
end;

end.
