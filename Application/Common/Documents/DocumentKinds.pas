unit DocumentKinds;

interface

type

  TDocumentKind = class
  end;

  TNativeDocumentKind = class (TDocumentKind)
  end;

  TOutcomingDocumentKind = class(TNativeDocumentKind)
  end;

  TApproveableDocumentKind = class(TNativeDocumentKind)
  end;

  TIncomingDocumentKind = class(TNativeDocumentKind)
  end;

  TInternalDocumentKind = class(TNativeDocumentKind)
  end;

  TOutcomingInternalDocumentKind = class (TNativeDocumentKind)
  end;

  TIncomingInternalDocumentKind = class (TIncomingDocumentKind)
  end;

type

  TServiceNoteKind = class(TNativeDocumentKind)
  end;

  TOutcomingServiceNoteKind = class(TOutcomingDocumentKind)
  end;

  TIncomingServiceNoteKind = class(TIncomingDocumentKind)
  end;

  TApproveableServiceNoteKind = class(TApproveableDocumentKind)
  end;
  
  TInternalServiceNoteKind = class (TInternalDocumentKind)
  end;

  TOutcomingInternalServiceNoteKind = class (TOutcomingInternalDocumentKind)
  end;

  TIncomingInternalServiceNoteKind = class (TIncomingInternalDocumentKind)
  end;

type

  { refactor: remove after remove NumericDocumentKindResolver }
  
  TORDKind = class

  end;

type

  TPersonnelOrderKind = class (TNativeDocumentKind)
  end;

  TApproveablePersonnelOrderKind = class (TApproveableDocumentKind)
  end;
  
type

  TOrderKind = class(TNativeDocumentKind)
  end;

  TApproveableOrderKind = class(TApproveableDocumentKind)
  end;

type

  TSDDocumentKind = class (TDocumentKind)
  
  end;

type

  TPlantDocumentKind = class (TDocumentKind)
  
  end;

type

  TDocumentKindClass = class of TDocumentKind;

  TNativeDocumentKindClass = class of TNativeDocumentKind;
  
  TIncomingDocumentKindClass = class of TIncomingDocumentKind;

  TIncomingInternalDocumentKindClass = class of TIncomingInternalDocumentKind;

  TOutcomingInternalDocumentKindClass = class of TOutcomingInternalDocumentKind;
  
  TOutcomingDocumentKindClass = class of TOutcomingDocumentKind;

  TApproveableDocumentKindClass = class of TApproveableDocumentKind;

implementation

end.

