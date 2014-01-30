// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: ib/common.proto

#ifndef PROTOBUF_ib_2fcommon_2eproto__INCLUDED
#define PROTOBUF_ib_2fcommon_2eproto__INCLUDED

#include <string>

#include <google/protobuf/stubs/common.h>

#if GOOGLE_PROTOBUF_VERSION < 2005000
#error This file was generated by a newer version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please update
#error your headers.
#endif
#if 2005000 < GOOGLE_PROTOBUF_MIN_PROTOC_VERSION
#error This file was generated by an older version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please
#error regenerate this file with a newer version of protoc.
#endif

#include <google/protobuf/generated_message_util.h>
#include <google/protobuf/message.h>
#include <google/protobuf/repeated_field.h>
#include <google/protobuf/extension_set.h>
#include <google/protobuf/unknown_field_set.h>
// @@protoc_insertion_point(includes)

namespace ib {

// Internal implementation detail -- do not call these.
void  protobuf_AddDesc_ib_2fcommon_2eproto();
void protobuf_AssignDesc_ib_2fcommon_2eproto();
void protobuf_ShutdownFile_ib_2fcommon_2eproto();

class WireMessage;

// ===================================================================

class WireMessage : public ::google::protobuf::Message {
 public:
  WireMessage();
  virtual ~WireMessage();

  WireMessage(const WireMessage& from);

  inline WireMessage& operator=(const WireMessage& from) {
    CopyFrom(from);
    return *this;
  }

  inline const ::google::protobuf::UnknownFieldSet& unknown_fields() const {
    return _unknown_fields_;
  }

  inline ::google::protobuf::UnknownFieldSet* mutable_unknown_fields() {
    return &_unknown_fields_;
  }

  static const ::google::protobuf::Descriptor* descriptor();
  static const WireMessage& default_instance();

  void Swap(WireMessage* other);

  // implements Message ----------------------------------------------

  WireMessage* New() const;
  void CopyFrom(const ::google::protobuf::Message& from);
  void MergeFrom(const ::google::protobuf::Message& from);
  void CopyFrom(const WireMessage& from);
  void MergeFrom(const WireMessage& from);
  void Clear();
  bool IsInitialized() const;

  int ByteSize() const;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input);
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const;
  ::google::protobuf::uint8* SerializeWithCachedSizesToArray(::google::protobuf::uint8* output) const;
  int GetCachedSize() const { return _cached_size_; }
  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const;
  public:

  ::google::protobuf::Metadata GetMetadata() const;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  // required string type_name = 1;
  inline bool has_type_name() const;
  inline void clear_type_name();
  static const int kTypeNameFieldNumber = 1;
  inline const ::std::string& type_name() const;
  inline void set_type_name(const ::std::string& value);
  inline void set_type_name(const char* value);
  inline void set_type_name(const char* value, size_t size);
  inline ::std::string* mutable_type_name();
  inline ::std::string* release_type_name();
  inline void set_allocated_type_name(::std::string* type_name);

  // required bytes message_data = 2;
  inline bool has_message_data() const;
  inline void clear_message_data();
  static const int kMessageDataFieldNumber = 2;
  inline const ::std::string& message_data() const;
  inline void set_message_data(const ::std::string& value);
  inline void set_message_data(const char* value);
  inline void set_message_data(const void* value, size_t size);
  inline ::std::string* mutable_message_data();
  inline ::std::string* release_message_data();
  inline void set_allocated_message_data(::std::string* message_data);

  // @@protoc_insertion_point(class_scope:ib.WireMessage)
 private:
  inline void set_has_type_name();
  inline void clear_has_type_name();
  inline void set_has_message_data();
  inline void clear_has_message_data();

  ::google::protobuf::UnknownFieldSet _unknown_fields_;

  ::std::string* type_name_;
  ::std::string* message_data_;

  mutable int _cached_size_;
  ::google::protobuf::uint32 _has_bits_[(2 + 31) / 32];

  friend void  protobuf_AddDesc_ib_2fcommon_2eproto();
  friend void protobuf_AssignDesc_ib_2fcommon_2eproto();
  friend void protobuf_ShutdownFile_ib_2fcommon_2eproto();

  void InitAsDefaultInstance();
  static WireMessage* default_instance_;
};
// ===================================================================


// ===================================================================

// WireMessage

// required string type_name = 1;
inline bool WireMessage::has_type_name() const {
  return (_has_bits_[0] & 0x00000001u) != 0;
}
inline void WireMessage::set_has_type_name() {
  _has_bits_[0] |= 0x00000001u;
}
inline void WireMessage::clear_has_type_name() {
  _has_bits_[0] &= ~0x00000001u;
}
inline void WireMessage::clear_type_name() {
  if (type_name_ != &::google::protobuf::internal::kEmptyString) {
    type_name_->clear();
  }
  clear_has_type_name();
}
inline const ::std::string& WireMessage::type_name() const {
  return *type_name_;
}
inline void WireMessage::set_type_name(const ::std::string& value) {
  set_has_type_name();
  if (type_name_ == &::google::protobuf::internal::kEmptyString) {
    type_name_ = new ::std::string;
  }
  type_name_->assign(value);
}
inline void WireMessage::set_type_name(const char* value) {
  set_has_type_name();
  if (type_name_ == &::google::protobuf::internal::kEmptyString) {
    type_name_ = new ::std::string;
  }
  type_name_->assign(value);
}
inline void WireMessage::set_type_name(const char* value, size_t size) {
  set_has_type_name();
  if (type_name_ == &::google::protobuf::internal::kEmptyString) {
    type_name_ = new ::std::string;
  }
  type_name_->assign(reinterpret_cast<const char*>(value), size);
}
inline ::std::string* WireMessage::mutable_type_name() {
  set_has_type_name();
  if (type_name_ == &::google::protobuf::internal::kEmptyString) {
    type_name_ = new ::std::string;
  }
  return type_name_;
}
inline ::std::string* WireMessage::release_type_name() {
  clear_has_type_name();
  if (type_name_ == &::google::protobuf::internal::kEmptyString) {
    return NULL;
  } else {
    ::std::string* temp = type_name_;
    type_name_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
    return temp;
  }
}
inline void WireMessage::set_allocated_type_name(::std::string* type_name) {
  if (type_name_ != &::google::protobuf::internal::kEmptyString) {
    delete type_name_;
  }
  if (type_name) {
    set_has_type_name();
    type_name_ = type_name;
  } else {
    clear_has_type_name();
    type_name_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
  }
}

// required bytes message_data = 2;
inline bool WireMessage::has_message_data() const {
  return (_has_bits_[0] & 0x00000002u) != 0;
}
inline void WireMessage::set_has_message_data() {
  _has_bits_[0] |= 0x00000002u;
}
inline void WireMessage::clear_has_message_data() {
  _has_bits_[0] &= ~0x00000002u;
}
inline void WireMessage::clear_message_data() {
  if (message_data_ != &::google::protobuf::internal::kEmptyString) {
    message_data_->clear();
  }
  clear_has_message_data();
}
inline const ::std::string& WireMessage::message_data() const {
  return *message_data_;
}
inline void WireMessage::set_message_data(const ::std::string& value) {
  set_has_message_data();
  if (message_data_ == &::google::protobuf::internal::kEmptyString) {
    message_data_ = new ::std::string;
  }
  message_data_->assign(value);
}
inline void WireMessage::set_message_data(const char* value) {
  set_has_message_data();
  if (message_data_ == &::google::protobuf::internal::kEmptyString) {
    message_data_ = new ::std::string;
  }
  message_data_->assign(value);
}
inline void WireMessage::set_message_data(const void* value, size_t size) {
  set_has_message_data();
  if (message_data_ == &::google::protobuf::internal::kEmptyString) {
    message_data_ = new ::std::string;
  }
  message_data_->assign(reinterpret_cast<const char*>(value), size);
}
inline ::std::string* WireMessage::mutable_message_data() {
  set_has_message_data();
  if (message_data_ == &::google::protobuf::internal::kEmptyString) {
    message_data_ = new ::std::string;
  }
  return message_data_;
}
inline ::std::string* WireMessage::release_message_data() {
  clear_has_message_data();
  if (message_data_ == &::google::protobuf::internal::kEmptyString) {
    return NULL;
  } else {
    ::std::string* temp = message_data_;
    message_data_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
    return temp;
  }
}
inline void WireMessage::set_allocated_message_data(::std::string* message_data) {
  if (message_data_ != &::google::protobuf::internal::kEmptyString) {
    delete message_data_;
  }
  if (message_data) {
    set_has_message_data();
    message_data_ = message_data;
  } else {
    clear_has_message_data();
    message_data_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
  }
}


// @@protoc_insertion_point(namespace_scope)

}  // namespace ib

#ifndef SWIG
namespace google {
namespace protobuf {


}  // namespace google
}  // namespace protobuf
#endif  // SWIG

// @@protoc_insertion_point(global_scope)

#endif  // PROTOBUF_ib_2fcommon_2eproto__INCLUDED