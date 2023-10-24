unit EmployeeDocumentKindAccessRightsInfo;

interface

uses

  DomainObjectValueUnit,
  SysUtils,
  Classes;

type

  TDocumentNumberPrefixPatternType = (ppNone, ppDigits, ppAnyChars);
  
  { refactor: CreateRespondingDocuments перенести в IncomingDocumentKindAccessRightsService }
  TEmployeeDocumentKindAccessRightsInfo = class (TDomainObjectValue)

    private

      FCanViewDocuments: Boolean;
      FCanCreateDocuments: Boolean;
      FCanCreateRespondingDocuments: Boolean;
      FCanEditDocuments: Boolean;
      FCanRemoveDocuments: Boolean;
      FCanMarkDocumentsAsSelfRegistered: Boolean;
      FDocumentNumberPrefixPatternType: TDocumentNumberPrefixPatternType;

    public

      function AllAccessRightsAbsent: Boolean;

      property CanViewDocuments: Boolean
      read FCanViewDocuments write FCanViewDocuments;
      
      property CanCreateDocuments: Boolean
      read FCanCreateDocuments
      write FCanCreateDocuments;

      property CanCreateRespondingDocuments: Boolean
      read FCanCreateRespondingDocuments
      write FCanCreateRespondingDocuments;
      
      property CanEditDocuments: Boolean
      read FCanEditDocuments write FCanEditDocuments;

      property CanRemoveDocuments: Boolean
      read FCanRemoveDocuments write FCanRemoveDocuments;
      
      property CanMarkDocumentsAsSelfRegistered: Boolean
      read FCanMarkDocumentsAsSelfRegistered
      write FCanMarkDocumentsAsSelfRegistered;

      property DocumentNumberPrefixPatternType: TDocumentNumberPrefixPatternType
      read FDocumentNumberPrefixPatternType
      write FDocumentNumberPrefixPatternType;
      
  end;

implementation

function TEmployeeDocumentKindAccessRightsInfo.AllAccessRightsAbsent: Boolean;
begin

  Result :=
    not (
      CanViewDocuments or
      CanCreateDocuments or
      CanEditDocuments or
      CanRemoveDocuments or
      CanMarkDocumentsAsSelfRegistered or
      CanCreateRespondingDocuments
    );

end;

end.
