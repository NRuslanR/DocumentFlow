unit EmployeeDocumentKindAccessRightsInfoDto;

interface

type

  
  TDocumentNumberPrefixPatternTypeDto = (ppNone, ppDigits, ppAnyChars);
  
  TEmployeeDocumentKindAccessRightsInfoDto = class

    public
    
      CanViewDocuments: Boolean;
      CanCreateDocuments: Boolean;
      CanCreateRespondingDocuments: Boolean;
      CanEditDocuments: Boolean;
      CanRemoveDocuments: Boolean;
      CanMarkDocumentsAsSelfRegistered: Boolean;
      DocumentNumberPrefixPatternType: TDocumentNumberPrefixPatternTypeDto;

  end;

implementation

end.
