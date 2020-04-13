/*
Copyright The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// Code generated by client-gen. DO NOT EDIT.

package v1

import (
	"context"
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	types "k8s.io/apimachinery/pkg/types"
	watch "k8s.io/apimachinery/pkg/watch"
	rest "k8s.io/client-go/rest"

	v1 "github.com/Azure/application-gateway-kubernetes-ingress/pkg/apis/azurebackendpool/v1"
	scheme "github.com/Azure/application-gateway-kubernetes-ingress/pkg/crd_client/agic_crd_client/clientset/versioned/scheme"
)

// AzureBackendPoolsGetter has a method to return a AzureBackendPoolInterface.
// A group's client should implement this interface.
type AzureBackendPoolsGetter interface {
	AzureBackendPools() AzureBackendPoolInterface
}

// AzureBackendPoolInterface has methods to work with AzureBackendPool resources.
type AzureBackendPoolInterface interface {
	Create(ctx context.Context, azureBackendPool *v1.AzureBackendPool, opts metav1.CreateOptions) (*v1.AzureBackendPool, error)
	Update(ctx context.Context, azureBackendPool *v1.AzureBackendPool, opts metav1.UpdateOptions) (*v1.AzureBackendPool, error)
	Delete(ctx context.Context, name string, opts metav1.DeleteOptions) error
	DeleteCollection(ctx context.Context, opts metav1.DeleteOptions, listOpts metav1.ListOptions) error
	Get(ctx context.Context, name string, opts metav1.GetOptions) (*v1.AzureBackendPool, error)
	List(ctx context.Context, opts metav1.ListOptions) (*v1.AzureBackendPoolList, error)
	Watch(ctx context.Context, opts metav1.ListOptions) (watch.Interface, error)
	Patch(ctx context.Context, name string, pt types.PatchType, data []byte, opts metav1.PatchOptions, subresources ...string) (result *v1.AzureBackendPool, err error)
	AzureBackendPoolExpansion
}

// azureBackendPools implements AzureBackendPoolInterface
type azureBackendPools struct {
	client rest.Interface
}

// newAzureBackendPools returns a AzureBackendPools
func newAzureBackendPools(c *AzurebackendpoolsV1Client) *azureBackendPools {
	return &azureBackendPools{
		client: c.RESTClient(),
	}
}

// Get takes name of the azureBackendPool, and returns the corresponding azureBackendPool object, and an error if there is any.
func (c *azureBackendPools) Get(ctx context.Context, name string, options metav1.GetOptions) (result *v1.AzureBackendPool, err error) {
	result = &v1.AzureBackendPool{}
	err = c.client.Get().
		Resource("azurebackendpools").
		Name(name).
		VersionedParams(&options, scheme.ParameterCodec).
		Do(ctx).
		Into(result)
	return
}

// List takes label and field selectors, and returns the list of AzureBackendPools that match those selectors.
func (c *azureBackendPools) List(ctx context.Context, opts metav1.ListOptions) (result *v1.AzureBackendPoolList, err error) {
	var timeout time.Duration
	if opts.TimeoutSeconds != nil {
		timeout = time.Duration(*opts.TimeoutSeconds) * time.Second
	}
	result = &v1.AzureBackendPoolList{}
	err = c.client.Get().
		Resource("azurebackendpools").
		VersionedParams(&opts, scheme.ParameterCodec).
		Timeout(timeout).
		Do(ctx).
		Into(result)
	return
}

// Watch returns a watch.Interface that watches the requested azureBackendPools.
func (c *azureBackendPools) Watch(ctx context.Context, opts metav1.ListOptions) (watch.Interface, error) {
	var timeout time.Duration
	if opts.TimeoutSeconds != nil {
		timeout = time.Duration(*opts.TimeoutSeconds) * time.Second
	}
	opts.Watch = true
	return c.client.Get().
		Resource("azurebackendpools").
		VersionedParams(&opts, scheme.ParameterCodec).
		Timeout(timeout).
		Watch(ctx)
}

// Create takes the representation of a azureBackendPool and creates it.  Returns the server's representation of the azureBackendPool, and an error, if there is any.
func (c *azureBackendPools) Create(ctx context.Context, azureBackendPool *v1.AzureBackendPool, opts metav1.CreateOptions) (result *v1.AzureBackendPool, err error) {
	result = &v1.AzureBackendPool{}
	err = c.client.Post().
		Resource("azurebackendpools").
		VersionedParams(&opts, scheme.ParameterCodec).
		Body(azureBackendPool).
		Do(ctx).
		Into(result)
	return
}

// Update takes the representation of a azureBackendPool and updates it. Returns the server's representation of the azureBackendPool, and an error, if there is any.
func (c *azureBackendPools) Update(ctx context.Context, azureBackendPool *v1.AzureBackendPool, opts metav1.UpdateOptions) (result *v1.AzureBackendPool, err error) {
	result = &v1.AzureBackendPool{}
	err = c.client.Put().
		Resource("azurebackendpools").
		Name(azureBackendPool.Name).
		VersionedParams(&opts, scheme.ParameterCodec).
		Body(azureBackendPool).
		Do(ctx).
		Into(result)
	return
}

// Delete takes name of the azureBackendPool and deletes it. Returns an error if one occurs.
func (c *azureBackendPools) Delete(ctx context.Context, name string, opts metav1.DeleteOptions) error {
	return c.client.Delete().
		Resource("azurebackendpools").
		Name(name).
		Body(&opts).
		Do(ctx).
		Error()
}

// DeleteCollection deletes a collection of objects.
func (c *azureBackendPools) DeleteCollection(ctx context.Context, opts metav1.DeleteOptions, listOpts metav1.ListOptions) error {
	var timeout time.Duration
	if listOpts.TimeoutSeconds != nil {
		timeout = time.Duration(*listOpts.TimeoutSeconds) * time.Second
	}
	return c.client.Delete().
		Resource("azurebackendpools").
		VersionedParams(&listOpts, scheme.ParameterCodec).
		Timeout(timeout).
		Body(&opts).
		Do(ctx).
		Error()
}

// Patch applies the patch and returns the patched azureBackendPool.
func (c *azureBackendPools) Patch(ctx context.Context, name string, pt types.PatchType, data []byte, opts metav1.PatchOptions, subresources ...string) (result *v1.AzureBackendPool, err error) {
	result = &v1.AzureBackendPool{}
	err = c.client.Patch(pt).
		Resource("azurebackendpools").
		Name(name).
		SubResource(subresources...).
		VersionedParams(&opts, scheme.ParameterCodec).
		Body(data).
		Do(ctx).
		Into(result)
	return
}
