unit DocumentChargeControlService;

interface

uses

  Employee,
  IDocumentUnit,
  DocumentCharges,
  DomainException,
  DocumentChargeAccessRights,
  DocumentChargeInterface,
  VariantListUnit,
  SysUtils;

type

  TDocumentChargeControlServiceException = class (TDomainException)
  
  end;

  TFailedRemovingDocumentChargesEnsuringException = class (TDocumentChargeControlServiceException)
  
    private

      FFailedDocumentCharges: IDocumentCharges;

    public

      constructor Create(
        FailedDocumentCharges: IDocumentCharges; 
        const Msg: String = ''
      ); overload;

      constructor Create(
        FailedDocumentCharges: IDocumentCharges; 
        const Msg: String;
        const Args: array of const
      ); overload;

      property FailedDocumentCharges: IDocumentCharges
      read FFailedDocumentCharges;
      
  end;

  TDocumentChargeNotFoundException = class (TDocumentChargeControlServiceException)
  
  end;
  
  IDocumentChargeControlService = interface

    procedure CreateDocumentCharges(
      const ChargeKindId: Variant;
      const Assigning: TEmployee;
      const Document: IDocument;
      const Performers: TEmployees;
      var DocumentCharges: IDocumentCharges;
      var AccessRightsList: TDocumentChargeAccessRightsList
    );

    procedure GetDocumentCharge(
      const ChargeId: Variant;
      const Document: IDocument;
      const Employee: TEmployee;
      var DocumentCharge: IDocumentCharge;
      var AccessRights: TDocumentChargeAccessRights
    );

    procedure EnsureEmployeeMayRemoveDocumentCharges(
      const Employee: TEmployee;
      const ChargeIds: TVariantList;
      const Document: IDocument
    );
    
  end;
  
implementation

{ TFailedRemovingDocumentChargesEnsuringException }

constructor TFailedRemovingDocumentChargesEnsuringException.Create(
  FailedDocumentCharges: IDocumentCharges; 
  const Msg: String;
  const Args: array of const
);
begin

  inherited CreateFmt(Msg, Args);

  FFailedDocumentCharges := FailedDocumentCharges;
  
end;

constructor TFailedRemovingDocumentChargesEnsuringException.Create(
  FailedDocumentCharges: IDocumentCharges; const Msg: String);
begin

  inherited Create(Msg);

  FFailedDocumentCharges := FailedDocumentCharges;

end;

end.
