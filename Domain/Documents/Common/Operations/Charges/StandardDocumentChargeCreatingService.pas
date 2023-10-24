unit StandardDocumentChargeCreatingService;

interface

uses

  DocumentChargeKindsControlService,
  DocumentChargeCreatingService,
  DocumentChargeInterface,
  DocumentCharges,
  DocumentChargeKind,
  DocumentPerforming,
  IDocumentUnit,
  Employee,
  SysUtils;

type

  TStandardDocumentChargeCreatingService =
    class (TInterfacedObject, IDocumentChargeCreatingService)

      protected

        FDocumentChargeKindsControlService: IDocumentChargeKindsControlService;

      public

        constructor Create(
          DocumentChargeKindsControlService: IDocumentChargeKindsControlService
        );

        function CreateDocumentCharge(
          const ChargeKindId: Variant;
          Document: IDocument;
          Performer: TEmployee
        ): IDocumentCharge; virtual;

        function CreateDocumentCharges(
          const ChargeKindId: Variant;
          Document: IDocument;
          Performers: TEmployees
        ): IDocumentCharges;
    
    end;

implementation

uses

  IDomainObjectBaseUnit,
  DocumentChargeRuleRegistry;
  
{ TStandardDocumentChargeCreatingService }

constructor TStandardDocumentChargeCreatingService.Create(
  DocumentChargeKindsControlService: IDocumentChargeKindsControlService);
begin

  inherited Create;

  FDocumentChargeKindsControlService := DocumentChargeKindsControlService;
  
end;

function TStandardDocumentChargeCreatingService.CreateDocumentCharges(
  const ChargeKindId: Variant;
  Document: IDocument;
  Performers: TEmployees
): IDocumentCharges;
var
    Performer: TEmployee;
begin

  Result := TDocumentCharges.Create;

  try

    for Performer in Performers do
      Result.AddCharge(CreateDocumentCharge(ChargeKindId, Document, Performer));
      
  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TStandardDocumentChargeCreatingService.CreateDocumentCharge(
  const ChargeKindId: Variant;
  Document: IDocument;
  Performer: TEmployee
): IDocumentCharge;
var
    DocumentCharge: TDocumentCharge;
    DocumentChargeKind: TDocumentChargeKind;
    FreeDocumentChargeKind: IDomainObjectBase;
begin

  DocumentChargeKind :=
    FDocumentChargeKindsControlService.FindDocumentChargeKindById(ChargeKindId);

  FreeDocumentChargeKind := DocumentChargeKind;

  DocumentCharge :=
    DocumentChargeKind
      .ChargeClass
        .Create(
          Performer,
          TDocumentChargeRuleRegistry.Instance.GetDocumentChargeWorkingRules(
            DocumentChargeKind.ChargeClass
          )
        );

  Result := DocumentCharge;

  DocumentCharge.InvariantsComplianceRequested := False;

  DocumentCharge.KindId := DocumentChargeKind.Identity;
  DocumentCharge.KindName := DocumentChargeKind.Name;
  DocumentCharge.ServiceKindName := DocumentChargeKind.ServiceName;
  DocumentCharge.DocumentId := Document.Identity;
  
  DocumentCharge.InvariantsComplianceRequested := True;

end;

end.
