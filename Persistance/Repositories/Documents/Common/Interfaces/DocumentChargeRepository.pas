unit DocumentChargeRepository;

interface

uses

  IGetSelfUnit,
  DocumentCharges,
  VariantListUnit;

type

  IDocumentChargeRepository = interface (IGetSelf)

    function FindDocumentChargeById(const ChargeId: Variant): TDocumentCharge;
    function FindDocumentChargeByIds(const ChargeIds: TVariantList): TDocumentCharges;
    function FindAllChargesForDocument(const DocumentId: Variant): TDocumentCharges;
    procedure AddDocumentCharges(DocumentCharges: TDocumentCharges);
    procedure UpdateDocumentCharge(DocumentCharge: TDocumentCharge);
    procedure UpdateDocumentCharges(DocumentCharges: TDocumentCharges);
    procedure SaveDocumentCharge(DocumentCharge: TDocumentCharge);
    procedure RemoveAllDocumentCharges(const DocumentId: Variant);

  end;
  
implementation

end.
