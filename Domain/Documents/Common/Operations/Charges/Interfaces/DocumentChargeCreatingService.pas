unit DocumentChargeCreatingService;

interface

uses

  DomainException,
  DocumentChargeInterface,
  IDocumentUnit,
  Employee,
  SysUtils;

type

  IDocumentChargeCreatingService = interface
    ['{00CD9A7C-B240-446F-8613-556788B50428}']

    function CreateDocumentCharge(
      const ChargeKindId: Variant;
      Document: IDocument;
      Performer: TEmployee
    ): IDocumentCharge;

    function CreateDocumentCharges(
      const ChargeKindId: Variant;
      Document: IDocument;
      Performers: TEmployees
    ): IDocumentCharges;

  end;

implementation

end.
