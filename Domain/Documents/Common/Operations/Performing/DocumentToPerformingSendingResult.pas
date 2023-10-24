unit DocumentToPerformingSendingResult;

interface

uses

  CreatingNecessaryDataForDocumentPerformingService,
  IDomainObjectBaseUnit,
  DomainObjectValueUnit,
  Employee,
  SysUtils;

type

  TDocumentToPerformingSendingResult = class (TDomainObjectValue)

    private

      FSender: TEmployee;
      FFreeSender: IDomainObjectBase;

      FSentNecessaryDataForDocumentPerforming: TNecessaryDataForDocumentPerforming;
      FFreeSentNecessaryDataForDocumentPerforming: IDomainObjectBase;

    public

      constructor Create(
        Sender: TEmployee;
        SentNecessaryDataForDocumentPerforming: TNecessaryDataForDocumentPerforming
      );

      property Sender: TEmployee read FSender;

      property SentNecessaryDataForDocumentPerforming: TNecessaryDataForDocumentPerforming
      read FSentNecessaryDataForDocumentPerforming;

  end;

implementation

{ TDocumentToPerformingSendingResult }

constructor TDocumentToPerformingSendingResult.Create(
  Sender: TEmployee;
  SentNecessaryDataForDocumentPerforming: TNecessaryDataForDocumentPerforming
);
begin

  inherited Create;

  FSender := Sender;
  FFreeSender := FSender;
  
  FSentNecessaryDataForDocumentPerforming := SentNecessaryDataForDocumentPerforming;
  FFreeSentNecessaryDataForDocumentPerforming := FSentNecessaryDataForDocumentPerforming;

end;

end.
